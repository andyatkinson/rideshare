require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  test "validity" do
    party_bus = Vehicle.new
    assert_not party_bus.valid?
    assert !party_bus.errors[:name].include?("be blank")
  end

  test "a vehicle is in a draft state by default" do
    vehicle = vehicles(:party_bus)
    assert vehicle.status_draft?
  end
end
