class VehicleReservation < ApplicationRecord
  belongs_to :vehicle
  belongs_to :trip_request

  validates :vehicle_id, :starts_at, :ends_at,
    presence: true

end
