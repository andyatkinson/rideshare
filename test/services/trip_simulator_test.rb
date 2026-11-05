require 'test_helper'

class TripSimulatorTest < ActiveSupport::TestCase
  def simulator(**options)
    TripSimulator.new(drivers: [drivers(:meg)], riders: [riders(:jessica)],
                      locations: [locations(:bos), locations(:nyc)],
                      interval: 0, jitter: 0, random: Random.new(42), **options)
  end

  test 'fulfills repeated trips with fixed actors, positions, completion then rating' do
    events = []
    actor_counts = [Driver.count, Rider.count, Location.count]
    runner = simulator(samples: 3, on_event: lambda { |event, trip|
      events << event
      assert_not Driver.idle.exists?(trip.driver_id) if event == :assigned
      assert_nil trip.reload.rating if event == :completed
      assert Driver.idle.exists?(trip.driver_id) if event == :idle
    })
    result = nil
    assert_difference -> { TripRequest.count }, 3 do
      assert_difference -> { Trip.count }, 3 do
        assert_difference -> { TripPosition.count }, 9 do
          result = runner.run(iterations: 3)
        end
      end
    end
    assert_equal actor_counts, [Driver.count, Rider.count, Location.count]
    assert_equal [:requested, :assigned, :pickup, :position, :position, :position, :completed, :rated, :idle] * 3, events
    result.each do |trip|
      assert_equal drivers(:meg).id, trip.driver_id
      assert_equal riders(:jessica).id, trip.rider.id
      assert trip.completed_at
      assert_includes 1..5, trip.rating
      positions = trip.trip_positions.order(:id)
      assert_equal trip.trip_request.start_location.position, positions.first.position
      assert_equal trip.trip_request.end_location.position, positions.last.position
      assert positions.all? { |position| position.created_at <= trip.completed_at }
    end
  end

  test 'does not create a request when its driver pool is busy' do
    runner = TripSimulator.new(drivers: [drivers(:jack)], riders: [riders(:jessica)],
                              locations: [locations(:bos), locations(:nyc)], interval: 0, jitter: 0)
    assert_no_difference -> { TripRequest.count } do
      assert_raises(TripSimulator::CapacityReached) { runner.run }
    end
  end

  test 'does not request another ride for a busy rider' do
    runner = TripSimulator.new(drivers: [drivers(:meg)], riders: [riders(:jane)],
                              locations: [locations(:bos), locations(:nyc)], interval: 0, jitter: 0)
    assert_no_difference -> { TripRequest.count } do
      assert_raises(TripSimulator::NoAvailableRider) { runner.run }
    end
  end

  test 'rejects invalid runs before creating records' do
    assert_raises(ArgumentError) { simulator(samples: 1) }
    assert_raises(ArgumentError) { simulator(interval: -1) }
    assert_no_difference -> { TripRequest.count } do
      assert_raises(ArgumentError) { simulator.run(iterations: 0) }
    end
  end

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

  test 'configuration validates inputs and preserves exact duration with uneven intervals' do
    configuration = TripSimulator::Configuration.new(concurrency: '10', sample_interval: '7', jitter_seconds: '30')
    assert_equal 10, configuration.concurrency
    assert_equal 7, configuration.sample_interval
    [{ concurrency: 0 }, { concurrency: 11 }, { sample_interval: 0 }, { sample_interval: Float::NAN },
     { jitter_seconds: -1 }, { jitter_seconds: 301 }, { duration_seconds: Float::INFINITY }].each do |invalid|
      assert_raises(ArgumentError) { TripSimulator::Configuration.new(**invalid) }
    end
    waits = []
    trip = simulator(interval: 7, duration: 360, sleeper: ->(seconds) { waits << seconds }).run.first
    assert_equal 360, waits.sum
    assert_equal 3, waits.last
    assert_equal 53, trip.trip_positions.count
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

  test 'fixed roster is reused on subsequent preparation' do
    pool = TripSimulator::Pool.new(driver_count: 2, rider_count: 3).prepare!
    assert_equal [2, 3, 7], [pool.drivers.size, pool.riders.size, pool.locations.size]
    assert pool.drivers.all?(&:valid?)
    assert pool.riders.all?(&:valid?)
    ids = [pool.drivers.map(&:id), pool.riders.map(&:id), pool.locations.map(&:id)]
    assert_no_difference -> { User.count + Location.count } do
      pool.prepare!
    end
    assert_equal ids, [pool.drivers.map(&:id), pool.riders.map(&:id), pool.locations.map(&:id)]
  end
end
