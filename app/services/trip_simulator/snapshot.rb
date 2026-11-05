class TripSimulator
  # Read committed database state; never prepare a pool or create records here.
  class Snapshot
    def call
      runner = Runner.status
      configuration = (runner[:configuration] || Configuration.new.to_h).symbolize_keys
      drivers = Pool.drivers([5, configuration.fetch(:concurrency, 1)].max)
      trips = self.class.trips
      active = trips.where(completed_at: nil).order(:id).limit(50).to_a
      recent = trips.completed.order(completed_at: :desc).limit(15).to_a
      rows = active + recent
      ActiveRecord::Associations::Preloader.new(
        records: rows, associations: [:driver, { trip_request: %i[rider start_location end_location] }]
      ).call
      samples = TripPosition.where(trip_id: rows.map(&:id)).group(:trip_id).count
      positions = TripPosition.where(trip_id: active.map(&:id)).order(:created_at, :id).group_by(&:trip_id)
      duration = runner[:running] ? runner[:duration_seconds] : 360
      busy = trips.where(completed_at: nil).pluck(:driver_id)
      {
        captured_at: Time.current.iso8601, runner: runner,
        locations: Pool::LOCATIONS.map { |address, _state, point, _key| { name: address, point: point } },
        counts: { drivers: Driver.count, riders: Rider.count, locations: Location.count,
                  requests: TripRequest.count, trips: Trip.count, positions: TripPosition.count },
        drivers: drivers.map { |driver| { id: driver.id, name: name(driver), busy: busy.include?(driver.id) } },
        active: active.map { |trip| serialize(trip, samples).merge(timing(trip, duration)).merge(route: self.class.route(trip), positions: positions.fetch(trip.id, []).map { |position| self.class.position(position) }) },
        recent: recent.map { |trip| serialize(trip, samples) }
      }
    end

    def self.trips
      locations = Location.where(address: Pool::LOCATIONS.map(&:first)).select(:id)
      requests = TripRequest.where(start_location_id: locations, end_location_id: locations).select(:id)
      Trip.where(driver_id: Pool.drivers.select(:id), trip_request_id: requests)
    end

    def self.route(trip)
      request = trip.trip_request
      Route.path(request.start_location, request.end_location)
    end

    def self.position(record)
      { id: record.id, lat: record.position.x, lng: record.position.y, recorded_at: record.created_at.iso8601 }
    end

    private

    def timing(trip, duration)
      elapsed = [((Time.current - trip.created_at).to_f).floor, 0].max
      { elapsed_seconds: elapsed, remaining_seconds: [(duration - elapsed).ceil, 0].max }
    end

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
