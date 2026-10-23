class TripPosition < PgdogRecord
  scope :for_trip, ->(trip_id) { where(trip_id: trip_id).order(:created_at) }

  # Execute the primary query before querying PgDog; a relation would become
  # a SQL subquery against the shards, where the trips table does not exist.
  scope :for_trips, ->(trips) { for_trip(trips.pluck(:id)) }

  belongs_to :trip

  validates :trip_id, presence: true
  validates :position, presence: true
end
