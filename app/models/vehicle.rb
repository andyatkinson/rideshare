class Vehicle < ApplicationRecord
  validates :name, presence: true

  attr_accessor :status

  has_many :vehicle_reservations

  class VehicleStatus
    DRAFT = 'draft'.freeze
    PUBLISHED = 'published'.freeze
    VALID_STATUSES = [
      DRAFT,
      PUBLISHED
    ]
  end

  enum status: {
    draft: VehicleStatus::DRAFT,
    published: VehicleStatus::PUBLISHED
  }, _prefix: true

  validates :status, inclusion: { in: VehicleStatus::VALID_STATUSES }

end
