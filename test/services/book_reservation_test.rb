require 'test_helper'

class BookReservationTest < ActiveSupport::TestCase
  test "can book reservation" do
    jane = riders(:jane)
    nyc = locations(:nyc)
    comedy_cellar = locations(:comedy_cellar)
    party_bus = vehicles(:party_bus)

    reservation = BookReservation.new(
      vehicle_id: party_bus.id,
      rider_id: jane.id,
      start_location_id: nyc.id,
      end_location_id: comedy_cellar.id,
      starts_at: '2022-07-29 20:00:00',
      ends_at: '2022-07-29 23:00:00'
    )

    assert_difference -> { ::VehicleReservation.count }, +1 do
      reservation.reserve!
    end
  end
end
