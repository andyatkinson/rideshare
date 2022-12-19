class TripCreator
  class TripCreationFailure < StandardError; end

  attr_reader :trip_request_id

  def initialize(trip_request_id:)
    @trip_request_id = trip_request_id
  end

  def create_trip!
    trip = Trip.new(
      trip_request_id: trip_request.id,
      driver: best_available_driver
    )
    raise TripCreationFailure unless trip.valid?
    trip.save!
  end

  private

  # NOTE: this would be a place to add intelligence
  # to the selection process:
  # available? completing a trip nearby? other business
  # criteria like tenure, driver score etc.
  def best_available_driver
    Driver.all.sample
  end

  def trip_request
    @trip_request ||= TripRequest.find(trip_request_id)
  end
end
