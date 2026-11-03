require 'test_helper'

class TripSimulatorConcurrencyTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test 'two trips run concurrently and a third cannot start' do
    pool = TripSimulator::Pool.new.prepare!
    ready, release = Queue.new, Queue.new
    observer = lambda do |event, _trip|
      if event == :assigned
        ready << true
        release.pop
      end
    end
    simulator = TripSimulator.new(drivers: pool.drivers, riders: pool.riders, locations: pool.locations,
                                  samples: 2, interval: 0, on_event: observer)
    worker = Thread.new { simulator.run(iterations: 2, concurrency: 2) }
    Timeout.timeout(10) { 2.times { ready.pop } }
    assert_equal 2, TripSimulator::Snapshot.trips.where(completed_at: nil).count
    assert_equal 5, TripSimulator::Pool.drivers.count
    assert_no_difference -> { TripRequest.count } do
      assert_raises(TripSimulator::CapacityReached) { simulator.run }
    end
    2.times { release << true }
    results = worker.value
    assert_equal 2, results.size
    assert_equal 2, results.map(&:driver_id).uniq.size
    assert results.all?(&:completed_at)
    assert_equal 0, TripSimulator::Snapshot.trips.where(completed_at: nil).count
  ensure
    2.times { release << true } if release
    worker&.join
    if pool
      trips = Trip.where(driver_id: pool.drivers.map(&:id))
      requests = TripRequest.where(id: trips.select(:trip_request_id)).to_a
      TripPosition.where(trip_id: trips.select(:id)).delete_all
      trips.destroy_all
      requests.each(&:destroy!)
      (pool.drivers + pool.riders).each(&:destroy!)
      pool.locations.each(&:destroy!)
    end
  end
end
