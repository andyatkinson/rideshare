require 'test_helper'
require 'minitest/mock'

class SimulatorDashboardTest < ActionDispatch::IntegrationTest
  test 'dashboard is unavailable outside development' do
    get '/simulator'
    assert_response :not_found
    get '/simulator/snapshot'
    assert_response :not_found
    post '/simulator/start'
    assert_response :not_found
    post '/simulator/reset'
    assert_response :not_found
    get '/simulator/trips/1/positions'
    assert_response :not_found
  end

  test 'start returns accepted and repeated starts return conflict' do
    Rails.env.stub(:development?, true) do
      TripSimulator::Runner.stub(:reset, { running: false, removed_trips: 2 }) do
        post '/simulator/reset'
        assert_response :success
        assert_equal 2, response.parsed_body['removed_trips']
      end
      received = nil
      TripSimulator::Runner.stub(:start, ->(options) { received = options; { running: true } }) do
        post '/simulator/start', params: { concurrency: 8, sample_interval: 2, jitter_seconds: 15 }, as: :json
        assert_response :accepted
        assert_equal({ 'concurrency' => 8, 'sample_interval' => 2, 'jitter_seconds' => 15 }, received)
        assert response.parsed_body['running']
      end
      post '/simulator/start', params: { concurrency: 11 }, as: :json
      assert_response :unprocessable_entity
      TripSimulator::Runner.stub(:start, ->(*) { raise TripSimulator::Runner::AlreadyRunning, 'Already running' }) do
        post '/simulator/start'
        assert_response :conflict
      end
    end
  end

  test 'dashboard observes lifecycle without adding records' do
    Rails.env.stub(:development?, true) do
      get '/simulator'
      assert_response :success
      assert_select 'h1', 'Rideshare activity'
      pool = TripSimulator::Pool.new(driver_count: 1, rider_count: 1).prepare!
      events = []
      observer = lambda do |event, active_trip|
        next unless %i[assigned position idle].include?(event)

        get '/simulator/snapshot'
        assert_response :success
        events << [event, response.parsed_body]
        if event == :assigned
          travel_to(active_trip.created_at + 90.seconds, with_usec: true) do
            get '/simulator/snapshot'
            timer = response.parsed_body['active'].first
            assert_equal 90, timer['elapsed_seconds']
            assert_equal 270, timer['remaining_seconds']
            TripSimulator::Runner.stub(:status, { running: true, duration_seconds: 120 }) do
              get '/simulator/snapshot'
              assert_equal 30, response.parsed_body['active'].first['remaining_seconds']
            end
          end
        end
        assert_equal 'no-store', response.headers['Cache-Control']
      end
      runner = TripSimulator.new(drivers: pool.drivers, riders: pool.riders, locations: pool.locations,
                                 samples: 2, interval: 0, jitter: 0, on_event: observer)
      trip = runner.run.first
      assigned = events.assoc(:assigned).last
      idle = events.assoc(:idle).last
      moving = events.assoc(:position).last
      assert_equal 1, moving['active'].first['positions'].length
      assert_equal trip.trip_request.start_location.position.x, moving['active'].first['positions'].first['lat']
      assert assigned['drivers'].first['busy']
      assert_equal 1, assigned['active'].length
      assert_equal 0, assigned['active'].first['samples']
      assert_not idle['drivers'].first['busy']
      assert_empty idle['active']
      assert_equal 2, idle['recent'].first['samples']
      assert_empty assigned['active'].first['positions']
      route = assigned['active'].first['route']
      assert_operator route.length, :>, 2
      assert_equal [trip.trip_request.start_location.position.x, trip.trip_request.start_location.position.y], route.first
      assert_equal [trip.trip_request.end_location.position.x, trip.trip_request.end_location.position.y], route.last
      get "/simulator/trips/#{trip.id}/positions"
      assert_response :success
      assert_equal route, response.parsed_body['route']
      positions = response.parsed_body['positions']
      assert_equal 2, positions.size
      assert_equal trip.trip_request.start_location.position.x, positions.first['lat']
      assert_equal trip.trip_request.start_location.position.y, positions.first['lng']
      assert_equal trip.trip_positions.order(:created_at, :id).pluck(:id), positions.map { |position| position['id'] }
      get "/simulator/trips/#{Trip.where.not(id: trip.id).first.id}/positions"
      assert_response :not_found
      assert_includes 1..5, idle['recent'].first['rating']
      assert_equal assigned['counts']['positions'] + 2, idle['counts']['positions']
      assert_no_difference -> { User.count + Location.count + TripRequest.count + Trip.count + TripPosition.count } do
        get '/simulator/snapshot'
        assert_response :success
      end
    end
  end
end
