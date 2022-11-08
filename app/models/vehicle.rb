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

  validates :status, inclusion: { in: VehicleStatus::VALID_STATUSES }

  before_validation :set_status
  before_save :validate_status

  private

  def set_status
    self.status = VehicleStatus::DRAFT
  end
end
