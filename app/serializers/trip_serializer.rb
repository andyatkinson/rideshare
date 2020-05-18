class TripSerializer
  include FastJsonapi::ObjectSerializer

  attribute :rider_name do |trip|
    trip.rider.display_name
  end

  attribute :driver_name do |trip|
    trip.driver.display_name
  end

  belongs_to :driver
end
