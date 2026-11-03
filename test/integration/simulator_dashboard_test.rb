require 'test_helper'
require 'minitest/mock'

class SimulatorDashboardTest < ActionDispatch::IntegrationTest
  test 'dashboard is unavailable outside development' do
    get '/simulator'
    assert_response :not_found
    get '/simulator/snapshot'
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
        next unless %i[assigned idle].include?(event)

        get '/simulator/snapshot'
        assert_response :success
        events << [event, response.parsed_body]
        assert_equal 'no-store', response.headers['Cache-Control']
      end
      runner = TripSimulator.new(drivers: pool.drivers, riders: pool.riders, locations: pool.locations,
                                 samples: 2, interval: 0, on_event: observer)
      runner.run
      assigned, idle = events.map(&:last)
      assert assigned['drivers'].first['busy']
      assert_equal 1, assigned['active'].length
      assert_equal 0, assigned['active'].first['samples']
      assert_not idle['drivers'].first['busy']
      assert_empty idle['active']
      assert_equal 2, idle['recent'].first['samples']
      assert_includes 1..5, idle['recent'].first['rating']
      assert_equal assigned['counts']['positions'] + 2, idle['counts']['positions']
      assert_no_difference -> { User.count + Location.count + TripRequest.count + Trip.count + TripPosition.count } do
        get '/simulator/snapshot'
        assert_response :success
      end
    end
  end
end
