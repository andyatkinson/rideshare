class Trip < ApplicationRecord
  belongs_to :trip_request
  belongs_to :driver, class_name: 'User', counter_cache: true
  has_many :trip_positions

  delegate :rider, to: :trip_request, allow_nil: false

  validates :trip_request, :rider, :driver, presence: true

  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
  }, allow_nil: true

  validate :rating_requires_completed_trip

  scope :with_start_location, -> (text) {
    joins(trip_request: :start_location).
    where('locations.address ILIKE ?', "%#{text}%")
  }

  scope :with_driver_name, -> (text) {
    joins(:driver).
    where('users.first_name ILIKE ?', "%#{text}%")
  }

  scope :with_rider_name, -> (text) {
    joins(trip_request: :rider).
    where('users.first_name ILIKE ?', "%#{text}%")
  }

  scope :completed, -> { where.not(completed_at: nil) }

  def rating_requires_completed_trip
    if rating_changed? && completed_at.nil?
      errors.add(:rating, "must be completed before a rating can be added")
    end
  end

  def self.apply_scopes(*filters)
    filters.inject(all) do |scope_chain, filter|
      scope_chain.merge(filter)
    end
  end
end
