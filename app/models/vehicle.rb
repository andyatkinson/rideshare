class Vehicle < ApplicationRecord
  validates :name, presence: true

  attr_accessor :status

  has_many :vehicle_reservations

  enum status: {
    draft: VehicleStatus::DRAFT,
    published: VehicleStatus::PUBLISHED
  }, _prefix: true

  validates :status,
    inclusion: { in: VehicleStatus::VALID_STATUSES },
    presence: true

end
