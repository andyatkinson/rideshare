class TripRequest < ApplicationRecord
  belongs_to :rider
  belongs_to :start_location, class_name: 'Location'
  belongs_to :end_location, class_name: 'Location'

  validates :rider, :start_location, :end_location, presence: true
end
