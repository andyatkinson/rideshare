require "test_helper"

class VehicleReservationTest < ActiveSupport::TestCase
  test "validity" do
    party_bus = VehicleReservation.new
    assert_not party_bus.valid?
    assert !party_bus.errors[:vehicle_id].include?("be blank")
    assert !party_bus.errors[:starts_at].include?("be blank")
    assert !party_bus.errors[:ends_at].include?("be blank")
  end
end
