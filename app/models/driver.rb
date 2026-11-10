class Driver < User
  has_many :trips

  scope :idle, -> { where.not(id: Trip.where(completed_at: nil).select(:driver_id)) }

  validates :drivers_license_number,
            presence: true,
            uniqueness: true,
            drivers_license: true

  # X out of 5, with 1 to 5 options selected by Riders
  def average_rating
    trips.average(:rating)
  end
end
