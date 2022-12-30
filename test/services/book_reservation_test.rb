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
      starts_at: Time.zone.local(2022, 07, 29, 20, 00, 00),
      ends_at: Time.zone.local(2022, 07, 29, 23, 00, 00)
    )

    assert_difference -> { ::VehicleReservation.count }, +1 do
      reservation.reserve!
    end
  end

  test "can NOT book overlapping reservation" do
    existing_reservation = vehicle_reservations(:party_bus)

    violation_msg = 'PG::ExclusionViolation: ERROR:  " +
    "conflicting key value violates exclusion constraint "non_overlapping_vehicle_registration"'

    assert_no_difference -> { ::VehicleReservation.count } do
      assert_raises(ActiveRecord::StatementInvalid, violation_msg) do
        new_reservation = BookReservation.new(
          vehicle_id: existing_reservation.vehicle_id,
          rider_id: existing_reservation.trip_request.rider.id,
          start_location_id: existing_reservation.trip_request.start_location.id,
          end_location_id: existing_reservation.trip_request.end_location.id,
          starts_at: (existing_reservation.starts_at + 1.hour).to_s,
          ends_at: (existing_reservation.starts_at + 2.hours).to_s
        )

        new_reservation.reserve!
      end
    end
  end
end
