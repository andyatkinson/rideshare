class BookReservation

  def initialize(vehicle_id:, rider_id:,
                 start_location_id:, end_location_id:,
                 starts_at:, ends_at:
                )
    @vehicle = Vehicle.find(vehicle_id)
    @rider = Rider.find(rider_id)
    @start_location = Location.find(start_location_id)
    @end_location = Location.find(end_location_id)
    @starts_at = starts_at
    @ends_at = ends_at
  end

  def reserve!
    ActiveRecord::Base.transaction do
      trip_request = TripRequest.create!(
        rider: @rider,
        start_location: @start_location,
        end_location: @end_location
      )

      trip_request.vehicle_reservations.create!(
        vehicle: @vehicle,
        starts_at: @starts_at,
        ends_at: @ends_at
      )
    end
  end

end
