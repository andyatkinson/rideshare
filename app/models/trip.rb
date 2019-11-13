class Trip < ApplicationRecord
  belongs_to :trip_request
  belongs_to :driver

  delegate :rider, to: :trip_request, allow_nil: false

  validates :trip_request, :rider, :driver, presence: true

  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
  }, allow_nil: true

  validate :rating_requires_completed_trip

  def rating_requires_completed_trip
    if rating_changed? && completed_at.nil?
      errors.add(:rating, "must be completed before a rating can be added")
    end
  end
end
