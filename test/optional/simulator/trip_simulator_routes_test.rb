require 'test_helper'

class TripSimulatorRoutesTest < ActiveSupport::TestCase
  test 'street route uses endpoint positions and sleeps only between samples' do
    pool = TripSimulator::Pool.new(driver_count: 1, rider_count: 1).prepare!
    waits = []
    trip = TripSimulator.new(drivers: pool.drivers, riders: pool.riders, locations: pool.locations.first(2),
                            jitter: 0, sleeper: ->(seconds) { waits << seconds }).run.first
    points = trip.trip_positions.order(:id).map { |record| [record.position.x, record.position.y] }
    assert_equal 73, points.size
    assert_equal [5.0] * 72, waits
    assert_equal [trip.trip_request.start_location.position.x, trip.trip_request.start_location.position.y], points.first
    assert_equal [trip.trip_request.end_location.position.x, trip.trip_request.end_location.position.y], points.last
    assert points.all? { |lat, lng| (42.35..42.38).cover?(lat) && (-71.11..-71.08).cover?(lng) }
    # Street geometry bends away from the straight endpoint interpolation.
    midpoint = points[36]
    straight = points.first.zip(points.last).map { |a, b| (a + b) / 2 }
    assert_operator (midpoint[0] - straight[0]).abs + (midpoint[1] - straight[1]).abs, :>, 0.0001
  end

  test 'jitter precedes each request and all location pairs have offline road routes' do
    pool = TripSimulator::Pool.new(driver_count: 1, rider_count: 1).prepare!
    waits = []
    runner = TripSimulator.new(drivers: pool.drivers, riders: pool.riders, locations: pool.locations,
      samples: 2, interval: 0, jitter: 30, random: Random.new(42), sleeper: ->(seconds) { waits << seconds })
    trips = runner.run(iterations: 10)
    assert_equal 10, waits.length
    assert waits.all? { |seconds| seconds >= 0 && seconds <= 30 }
    assert_operator trips.map { |trip| trip.trip_request.start_location_id }.uniq.size, :>, 1
    pool.locations.permutation(2).each do |start, finish|
      path = TripSimulator::Route.path(start, finish)
      assert_operator path.size, :>, 2
      assert_equal [start.position.x, start.position.y], path.first
      assert_equal [finish.position.x, finish.position.y], path.last
    end
  end
end
