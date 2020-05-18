class Driver < User
  has_many :trips

  def average_rating
    trips.average(:rating)
  end
end
