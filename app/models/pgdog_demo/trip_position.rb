module PgdogDemo
  class TripPosition < Record
    self.table_name = 'rideshare.trip_positions'

    validates :trip_id, :position, presence: true

    scope :for_trip, ->(trip_id) { where(trip_id: trip_id).order(:created_at) }
  end
end
