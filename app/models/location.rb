class Location < ApplicationRecord
  validates :address,
    presence: true,
    uniqueness: true # simple approach, assumes fully address, all parts

  validates :position, presence: true
  validates :state,
    presence: true,
    length: { is: 2 }

  geocoded_by :address

  after_validation :geocode, if: ->(obj) { obj.address_changed? && obj.position.nil? }
end
