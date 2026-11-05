require 'test_helper'
require 'minitest/mock'

class TripSimulatorRunnerTest < ActiveSupport::TestCase
  test 'reset stops the locked child and removes only unfinished simulator trip data' do
    spawn = Process.method(:spawn)
    detach = Process.method(:detach)
    child, waiter = nil, nil
    replacement = lambda do |environment, *arguments, **options|
      options = arguments.last if arguments.last.is_a?(Hash)
      configuration = JSON.parse(environment.fetch('SIM_CONFIG'))
      assert_equal 3, configuration['concurrency']
      assert_equal 2, configuration['sample_interval']
      assert_equal 15, configuration['jitter_seconds']
      assert_equal '5', environment['RAILS_MAX_THREADS']
      child = spawn.call(environment, RbConfig.ruby, '-e', 'sleep 30', **options)
    end
    Rails.env.stub(:development?, true) do
      Process.stub(:spawn, replacement) do
        Process.stub(:detach, ->(pid) { waiter = detach.call(pid) }) do
          assert TripSimulator::Runner.start(concurrency: 3, sample_interval: 2, jitter_seconds: 15)[:running]
          assert TripSimulator::Runner.status[:running]
          assert_raises(TripSimulator::Runner::AlreadyRunning) { TripSimulator::Runner.start }
          Socket.stub(:gethostname, 'another-container') do
            assert_raises(TripSimulator::Runner::ResetFailed) { TripSimulator::Runner.reset }
          end
          assert TripSimulator::Runner.status[:running]
        end
      end
    end
    pool = TripSimulator::Pool.new(driver_count: 1, rider_count: 1).prepare!
    completed = TripSimulator.new(drivers: pool.drivers, riders: pool.riders,
                                  locations: pool.locations, samples: 2, interval: 0, jitter: 0).run.first
    request = TripRequest.create!(rider: pool.riders.first, start_location: pool.locations.first, end_location: pool.locations.last)
    unfinished = TripCreator.new(trip_request_id: request.id, driver_ids: pool.drivers.map(&:id)).create_trip!
    position = unfinished.trip_positions.create!(position: pool.locations.first.position)
    before_count = pool.drivers.first.reload.trips_count
    unrelated = trips(:incomplete_trip)
    Rails.env.stub(:development?, true) do
      result = TripSimulator::Runner.reset
      assert_equal 1, result[:removed_trips]
      assert_not result[:running]
    end
    waiter.value
    assert_not TripSimulator::Runner.status[:running]
    Rails.env.stub(:development?, true) { assert_equal 0, TripSimulator::Runner.reset[:removed_trips] }
    assert_not Trip.exists?(unfinished.id)
    assert_not TripRequest.exists?(request.id)
    assert_not TripPosition.exists?(position.id)
    assert Trip.exists?(completed.id)
    assert_equal 2, completed.trip_positions.count
    assert Trip.exists?(unrelated.id)
    assert Driver.idle.exists?(pool.drivers.first.id)
    assert_equal before_count - 1, pool.drivers.first.reload.trips_count
    assert_equal 5, TripSimulator::Pool.new.prepare!.drivers.size
  ensure
    Process.kill('TERM', child) rescue nil
    waiter&.join
  end
end
