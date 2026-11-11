require 'test_helper'

class TripSimulatorConcurrencyTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test 'ten workers share seven origins without holding connections while waiting' do
    pool = TripSimulator::Pool.new(driver_count: 10).prepare!
    ready, release, next_release = Queue.new, Queue.new, Queue.new
    waits, wait_lock = 0, Mutex.new
    sleeper = lambda do |seconds|
      if seconds == 1
        first_wave = wait_lock.synchronize { waits += 1; waits <= 7 }
        ready << true
        (first_wave ? release : next_release).pop
      else
        sleep 0.01
      end
    end
    simulator = TripSimulator.new(drivers: pool.drivers, riders: pool.riders, locations: pool.locations,
                                  samples: 2, interval: 1, jitter: 0, concurrency: 10, sleeper: sleeper)
    worker = Thread.new { simulator.run(iterations: 10) }
    Timeout.timeout(15) { 7.times { ready.pop } }
    active = TripSimulator::Snapshot.trips.where(completed_at: nil)
    assert_equal 7, active.count
    assert_equal 7, TripRequest.where(id: active.select(:trip_request_id)).distinct.count(:start_location_id)
    assert_equal 10, TripSimulator::Pool.drivers.count
    assert_no_difference -> { TripRequest.count } do
      assert_raises(TripSimulator::NoAvailableOrigin) { simulator.send(:in_connection) { simulator.send(:request_trip!) } }
    end
    7.times { release << true }
    Timeout.timeout(15) { 3.times { ready.pop } }
    remaining = Trip.uncached { TripSimulator::Snapshot.trips.where(completed_at: nil).to_a }
    assert_equal 3, remaining.size
    assert_equal 3, TripRequest.where(id: remaining.map(&:trip_request_id)).distinct.count(:start_location_id)
    3.times { next_release << true }
    trips = worker.value
    assert_equal 10, trips.size
    assert trips.all?(&:completed_at)
    assert trips.all? { |trip| trip.trip_request.start_location_id != trip.trip_request.end_location_id }
    assert_equal 0, Trip.uncached { TripSimulator::Snapshot.trips.where(completed_at: nil).count }
  ensure
    10.times { release << true; next_release << true } if release
    worker&.join
    if pool
      trips = Trip.where(driver_id: pool.drivers.map(&:id))
      requests = TripRequest.where(id: trips.select(:trip_request_id)).to_a
      TripPosition.where(trip_id: trips.pluck(:id)).delete_all
      trips.destroy_all
      requests.each(&:destroy!)
      (pool.drivers + pool.riders).each(&:destroy!)
      pool.locations.each(&:destroy!)
    end
  end
end
