# A bounded, single-process development workload. All state transitions are
# real model writes; actor pools are fixed while requests/trips/positions grow.
class TripSimulator
  class NoAvailableRider < StandardError; end

  def initialize(drivers:, riders:, locations:, samples: 13, interval: 30,
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

  def run(iterations: 1)
    count = Integer(iterations)
    raise ArgumentError, 'iterations must be positive' unless count.positive?

    Array.new(count) { fulfill(request_trip!) }
  end

  private

  def request_trip!
    # Refuse a new request before writing anything if our fixed pool is busy.
    driver = Driver.idle.where(id: @driver_ids).order(:id).to_a.sample(random: @random)
    raise TripCreator::NoAvailableDriver, 'No idle driver in the simulator pool' unless driver

    active_riders = TripRequest.joins(:trip).where(trips: { completed_at: nil }).select(:rider_id)
    rider = Rider.where(id: @rider_ids).where.not(id: active_riders).order(:id).to_a.sample(random: @random)
    raise NoAvailableRider, 'No idle rider in the simulator pool' unless rider

    start_location, end_location = @locations.sample(2, random: @random)
    TripRequest.transaction do
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
