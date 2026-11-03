class TripSimulator
  # Read committed database state; never prepare a pool or create records here.
  class Snapshot
    def call
      drivers = Driver.where('email ~ ?', '^sim-driver-[0-9]+@rideshare[.]test$').order(:id)
      trips = Trip.where(driver_id: drivers.select(:id))
      active = trips.where(completed_at: nil).order(:id).limit(50).to_a
      recent = trips.completed.order(completed_at: :desc).limit(15).to_a
      rows = active + recent
      ActiveRecord::Associations::Preloader.new(
        records: rows, associations: [:driver, { trip_request: %i[rider start_location end_location] }]
      ).call
      samples = TripPosition.where(trip_id: rows.map(&:id)).group(:trip_id).count
      busy = trips.where(completed_at: nil).pluck(:driver_id)
      {
        captured_at: Time.current.iso8601,
        counts: { drivers: Driver.count, riders: Rider.count, locations: Location.count,
                  requests: TripRequest.count, trips: Trip.count, positions: TripPosition.count },
        drivers: drivers.map { |driver| { id: driver.id, name: name(driver), busy: busy.include?(driver.id) } },
        active: active.map { |trip| serialize(trip, samples) },
        recent: recent.map { |trip| serialize(trip, samples) }
      }
    end

    private

    def name(user)
      [user.first_name, user.last_name].join(' ')
    end

    def serialize(trip, samples)
      request = trip.trip_request
      { id: trip.id, driver: name(trip.driver), rider: name(request.rider),
        origin: request.start_location.address, destination: request.end_location.address,
        samples: samples.fetch(trip.id, 0), completed_at: trip.completed_at&.iso8601,
        rating: trip.rating }
    end
  end
end
