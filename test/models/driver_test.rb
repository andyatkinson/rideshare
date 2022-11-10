require 'test_helper'

class DriverTest < ActiveSupport::TestCase
  test "valid driver" do
    assert driver = Driver.new(email: 'email@email.com')
    assert_not driver.valid?
    assert_equal ["can't be blank"], driver.errors[:first_name]
  end

  test "driver's license number format is validated" do
    assert driver = drivers(:meg)
    driver.drivers_license_number = "123"
    assert_not driver.valid?
    assert_equal ["is not a valid driver's license number"], driver.errors[:drivers_license_number]
  end

  test "driver's license number format must pass validation" do
    assert driver = drivers(:meg)
    driver.drivers_license_number = "P800000224322"
    assert driver.valid?, driver.errors.full_messages
  end
end
