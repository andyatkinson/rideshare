class Rider < User
  has_many :trip_requests
  has_many :trips, through: :trip_requests

end
