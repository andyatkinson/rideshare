class Driver < User
  has_many :trips

  validates :drivers_license_number,
    presence: true,
    uniqueness: true,
    drivers_license: true

  # X out of 5, with 1 to 5 options selected by Riders
  def average_rating
    trips.average(:rating)
  end

end
