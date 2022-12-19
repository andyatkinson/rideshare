class TripRequest < ApplicationRecord
  belongs_to :rider
  belongs_to :start_location, class_name: 'Location'
  belongs_to :end_location, class_name: 'Location'
  has_one :trip

  has_many :vehicle_reservations

  # A unique trip request could be per driver, start and end location, that is
  # in progress. In other words, in order to avoid duplicated data, require that
  # only trip could be in progress for a rider between the same locations.

  validates :rider, :start_location, :end_location, presence: true

  # used for simulation
  after_commit :create_trip, on: :create

  private

  def create_trip
    # make this a config param
    if Rails.env.development?
      Rails.logger.info "^^^^^^^^ SIMULATE FANCY SELECTION PROCESS ^^^^^^^^"
      sleep(10)
      TripCreator.new(trip_request_id: id).create_trip!
    end

  end
end
