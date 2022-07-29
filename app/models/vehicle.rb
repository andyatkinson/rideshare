class Vehicle < ApplicationRecord
  validates :name, presence: true

  has_many :vehicle_reservations
end
