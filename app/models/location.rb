class Location < ApplicationRecord
  validates :address,
    presence: true,
    uniqueness: true # simple approach, assumes fully address, all parts

  geocoded_by :address

  after_validation :geocode, if: ->(obj) { obj.address_changed? &&
                                           obj.latitude.nil? && obj.longitude.nil? }
end
