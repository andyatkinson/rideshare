class TripRequest < ApplicationRecord
  belongs_to :rider, class_name: 'User'
  belongs_to :start_location, class_name: 'Location'
  belongs_to :end_location, class_name: 'Location'
  has_one :trip

  has_many :vehicle_reservations

  # A unique trip request could be per driver, start and end location, that is
  # in progress. In other words, in order to avoid duplicated data, require that
  # only trip could be in progress for a rider between the same locations.

  validates :rider, :start_location, :end_location, presence: true

end
