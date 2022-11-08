require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  test "validity" do
    party_bus = Vehicle.new
    assert_not party_bus.valid?
    assert_equal ["can't be blank"], party_bus.errors[:name]
  end

  test "a vehicle is in a draft state by default" do
    party_bus = Vehicle.new(name: "draft vehicle")
    assert party_bus.valid?
    assert_equal Vehicle::VehicleStatus::DRAFT, party_bus.status
  end
end
