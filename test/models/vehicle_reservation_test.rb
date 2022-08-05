require "test_helper"

class VehicleReservationTest < ActiveSupport::TestCase
  test "validity" do
    party_bus = VehicleReservation.new
    assert_not party_bus.valid?
    assert_equal ["can't be blank"], party_bus.errors[:vehicle_id]
    assert_equal ["can't be blank"], party_bus.errors[:starts_at]
    assert_equal ["can't be blank"], party_bus.errors[:ends_at]
  end
end
