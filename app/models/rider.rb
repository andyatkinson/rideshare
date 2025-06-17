class Rider < User
  # https://github.com/evilmartians/activerecord-slotted_counters
  has_slotted_counter :trip_requests

  has_many :trip_requests
  has_many :trips, through: :trip_requests
end
