class TripCreator
  class TripCreationFailure < StandardError; end
  class NoAvailableDriver < TripCreationFailure; end

  attr_reader :trip_request_id

  def initialize(trip_request_id:, driver_ids: nil)
    @trip_request_id = trip_request_id
    @driver_ids = driver_ids
  end

  def create_trip!
    trip_request.with_lock do
      trip_request.trip || assign_trip!
    end
  end

  private

  def assign_trip!
    candidates = Driver.all
    candidates = candidates.where(id: @driver_ids) if @driver_ids

    loop do
      driver = candidates.idle.order(:id).lock('FOR UPDATE SKIP LOCKED').first
      raise NoAvailableDriver, 'No idle driver is available' unless driver

      # Recheck after acquiring the lock, in case a concurrent assignment committed.
      next if driver.trips.where(completed_at: nil).exists?

      return trip_request.create_trip!(driver: driver)
    end
  end

  def trip_request
    @trip_request ||= TripRequest.find(trip_request_id)
  end
end
