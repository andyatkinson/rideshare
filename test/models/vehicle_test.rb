require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  test "validity" do
    party_bus = Vehicle.new
    assert_not party_bus.valid?
    assert_equal ["can't be blank"], party_bus.errors[:name]
  end
end
