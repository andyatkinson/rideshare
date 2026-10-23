class TripPosition < PgdogRecord
  scope :for_trip, ->(trip_id) { where(trip_id: trip_id).order(:created_at) }

  belongs_to :trip

  validates :trip_id, presence: true
  validates :position, presence: true
end
