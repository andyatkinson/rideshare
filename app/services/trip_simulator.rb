# A bounded, single-process development workload. All state transitions are
# real model writes; actor pools are fixed while requests/trips/positions grow.
class TripSimulator
  class CapacityReached < StandardError; end
  class NoAvailableRider < StandardError; end

  def initialize(drivers:, riders:, locations:, samples: 37, interval: 10,
                 random: Random.new, sleeper: Kernel.method(:sleep), on_event: ->(*) {})
    @driver_ids = drivers.map(&:id)
    @rider_ids = riders.map(&:id)
    @locations = locations.to_a.uniq(&:id)
    @samples = Integer(samples)
    @interval = Float(interval)
    raise ArgumentError, 'At least one driver and rider are required' if @driver_ids.empty? || @rider_ids.empty?
    raise ArgumentError, 'At least two distinct locations are required' if @locations.map(&:id).uniq.size < 2
    raise ArgumentError, 'samples must be at least 2' if @samples < 2
    raise ArgumentError, 'interval must be finite and nonnegative' unless @interval.finite? && @interval >= 0

    @random, @sleeper, @on_event = random, sleeper, on_event
  end

  def run(iterations: 1, concurrency: 1)
    count = Integer(iterations)
    workers = Integer(concurrency)
    raise ArgumentError, 'iterations must be positive' unless count.positive?
    raise ArgumentError, 'concurrency must be 1 or 2' unless (1..2).cover?(workers)
    return Array.new(count) { fulfill(request_trip!) } if workers == 1

    queue = Queue.new
    count.times { |index| queue << index }
    results, errors = Array.new(count), Queue.new
    threads = Array.new([workers, count].min) do
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          loop do
            index = begin
              queue.pop(true)
            rescue ThreadError
              break
            end
            results[index] = fulfill(request_trip!)
          end
        end
      rescue StandardError => error
        errors << error
      end
    end
    threads.each(&:join)
    raise errors.pop unless errors.empty?

    results
  end

  private

  def request_trip!
    TripRequest.transaction do
      # Serialize only assignment, never the journey. Also covers other CLI runs.
      TripRequest.connection.execute('SELECT pg_advisory_xact_lock(72493021)')
      driver_ids = Driver.where('email ~ ?', '^sim-driver-[0-9]+@rideshare[.]test$').pluck(:id) | @driver_ids
      active_trips = Trip.where(driver_id: driver_ids, completed_at: nil)
      if active_trips.count >= 2
        raise CapacityReached, 'Two simulator trips are already active'
      end
      driver = Driver.idle.where(id: @driver_ids).order(:id).to_a.sample(random: @random)
      raise TripCreator::NoAvailableDriver, 'No idle driver in the simulator pool' unless driver

      active_riders = TripRequest.joins(:trip).where(trips: { completed_at: nil }).select(:rider_id)
      rider = Rider.where(id: @rider_ids).where.not(id: active_riders).order(:id).to_a.sample(random: @random)
      raise NoAvailableRider, 'No idle rider in the simulator pool' unless rider

      location_ids = @locations.map(&:id)
      other_request = TripRequest.where(id: active_trips.select(:trip_request_id),
                                        start_location_id: location_ids, end_location_id: location_ids).first
      start_location, end_location = if other_request
                                       [@locations.find { |location| location.id == other_request.end_location_id },
                                        @locations.find { |location| location.id == other_request.start_location_id }]
                                     else
                                       @locations.sample(2, random: @random)
                                     end
      request = TripRequest.create!(rider: rider, start_location: start_location, end_location: end_location)
      trip = TripCreator.new(trip_request_id: request.id, driver_ids: [driver.id]).create_trip!
      emit(:requested, trip)
      trip
    end.tap { |trip| emit(:assigned, trip) }
  end

  def fulfill(trip)
    emit(:pickup, trip)
    start = trip.trip_request.start_location
    finish = trip.trip_request.end_location
    @samples.times do |index|
      fraction = index.fdiv(@samples - 1)
      @sleeper.call(@interval) if index.positive? && @interval.positive?
      trip.trip_positions.create!(position: Route.point(start, finish, fraction))
      emit(:position, trip)
    end
    trip.update!(completed_at: Time.current)
    emit(:completed, trip)
    trip.update!(rating: @random.rand(1..5))
    emit(:rated, trip)
    emit(:idle, trip)
    trip
  end

  def emit(event, trip)
    @on_event.call(event, trip)
  end
end
