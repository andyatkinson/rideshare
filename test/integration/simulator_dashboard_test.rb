require 'test_helper'
require 'minitest/mock'

class SimulatorDashboardTest < ActionDispatch::IntegrationTest
  test 'dashboard is unavailable outside development' do
    get '/simulator'
    assert_response :not_found
    get '/simulator/snapshot'
    assert_response :not_found
    get '/simulator/trips/1/positions'
    assert_response :not_found
  end

  test 'dashboard observes lifecycle without adding records' do
    Rails.env.stub(:development?, true) do
      get '/simulator'
      assert_response :success
      assert_select 'h1', 'Rideshare activity'
      pool = TripSimulator::Pool.new(driver_count: 1, rider_count: 1).prepare!
      events = []
      observer = lambda do |event, _trip|
        next unless %i[assigned position idle].include?(event)

        get '/simulator/snapshot'
        assert_response :success
        events << [event, response.parsed_body]
        assert_equal 'no-store', response.headers['Cache-Control']
      end
      runner = TripSimulator.new(drivers: pool.drivers, riders: pool.riders, locations: pool.locations,
                                 samples: 2, interval: 0, on_event: observer)
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
      get "/simulator/trips/#{trip.id}/positions"
      assert_response :success
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
