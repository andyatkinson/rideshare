class Location < ApplicationRecord
  validates :address, :latitude, :longitude, presence: true
end
