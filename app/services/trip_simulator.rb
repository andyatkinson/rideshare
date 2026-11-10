# A bounded, single-process development workload. All state transitions are
# real model writes; actor pools are fixed while requests/trips/positions grow.
class TripSimulator
  class CapacityReached < StandardError; end
  class NoAvailableRider < StandardError; end
  class NoAvailableOrigin < StandardError; end

  def initialize(drivers:, riders:, locations:, samples: 73, interval: 5, concurrency: 1, jitter: 30, duration: nil,
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

    @concurrency, @jitter = Integer(concurrency), Float(jitter)
    @duration = duration.nil? ? nil : Float(duration)
    raise ArgumentError, 'concurrency must be between 1 and 10' unless (1..10).cover?(@concurrency)
    raise ArgumentError, 'Pool is smaller than concurrency' if @driver_ids.size < @concurrency || @rider_ids.size < @concurrency
    raise ArgumentError, 'jitter must be finite and nonnegative' unless @jitter.finite? && @jitter >= 0
    raise ArgumentError, 'duration requires a positive interval and duration' if @duration && (!@duration.finite? || @duration <= 0 || @interval <= 0)

    @random, @sleeper, @on_event = random, sleeper, on_event
  end

  def run(iterations: 1)
    count = Integer(iterations)
    raise ArgumentError, 'iterations must be positive' unless count.positive?

    return Array.new(count) { run_trip } if @concurrency == 1

    queue = Queue.new
    count.times { |index| queue << index }
    results, errors = Array.new(count), Queue.new
    workers = Array.new([@concurrency, count].min) do
      Thread.new do
        loop do
          index = begin
            queue.pop(true)
          rescue ThreadError
            break
          end
          results[index] = run_trip
        end
      rescue StandardError => error
        Rails.logger.error("Simulator worker failed: #{error.class}: #{error.message}")
        errors << error
      end
    end
    workers.each(&:join)
    raise errors.pop unless errors.empty?

    results
  end

  private

  def in_connection(&block)
    ActiveRecord::Base.connection_pool.with_connection(prevent_permanent_checkout: true, &block)
  end

  def run_trip
    @sleeper.call(@random.rand * @jitter) if @jitter.positive?
    trip = loop do
      begin
        break in_connection { request_trip! }
      rescue NoAvailableOrigin
        # Wait outside the connection pool; Stop all terminates waiting workers too.
        @sleeper.call(0.5)
      end
    end
    fulfill(trip)
  end

  def request_trip!
    TripRequest.transaction do
      # Serialize only assignment, never the journey. Also covers other CLI runs.
      TripRequest.connection.execute('SELECT pg_advisory_xact_lock(72493021)')
      driver_ids = Driver.where('email ~ ?', '^sim-driver-[0-9]+@rideshare[.]test$').pluck(:id) | @driver_ids
      active_trips = Trip.where(driver_id: driver_ids, completed_at: nil)
      if active_trips.count >= @concurrency
        raise CapacityReached, "Simulator concurrency limit (#{@concurrency}) reached"
      end
      occupied_origins = TripRequest.where(id: active_trips.select(:trip_request_id)).pluck(:start_location_id)
      start_location = @locations.reject { |location| occupied_origins.include?(location.id) }.sample(random: @random)
      raise NoAvailableOrigin, 'All simulator pickup locations are occupied' unless start_location

      driver = Driver.idle.where(id: @driver_ids).order(:id).to_a.sample(random: @random)
      raise TripCreator::NoAvailableDriver, 'No idle driver in the simulator pool' unless driver

      active_riders = TripRequest.joins(:trip).where(trips: { completed_at: nil }).select(:rider_id)
      rider = Rider.where(id: @rider_ids).where.not(id: active_riders).order(:id).to_a.sample(random: @random)
      raise NoAvailableRider, 'No idle rider in the simulator pool' unless rider

      end_location = @locations.reject { |location| location.id == start_location.id }.sample(random: @random)
      request = TripRequest.create!(rider: rider, start_location: start_location, end_location: end_location)
      trip = TripCreator.new(trip_request_id: request.id, driver_ids: [driver.id]).create_trip!
      emit(:requested, trip)
      trip
    end.tap { |trip| emit(:assigned, trip) }
  end

  def fulfill(trip)
    in_connection { emit(:pickup, trip) }
    start, finish = in_connection { [trip.trip_request.start_location, trip.trip_request.end_location] }
    offsets = if @duration
                Array.new((@duration / @interval).ceil + 1) { |index| [index * @interval, @duration].min }
              else
                Array.new(@samples) { |index| index * @interval }
              end
    offsets.each_with_index do |offset, index|
      wait = index.zero? ? 0 : offset - offsets[index - 1]
      @sleeper.call(wait) if wait.positive?
      fraction = @duration ? offset / @duration : index.fdiv(@samples - 1)
      in_connection do
        trip.trip_positions.create!(position: Route.point(start, finish, fraction))
        emit(:position, trip)
      end
    end
    in_connection do
      trip.update!(completed_at: Time.current)
      emit(:completed, trip)
      trip.update!(rating: @random.rand(1..5))
      emit(:rated, trip)
      emit(:idle, trip)
    end
    trip
  end

  def emit(event, trip)
    @on_event.call(event, trip)
  end
end
