require 'test_helper'

class DriverTest < ActiveSupport::TestCase
  test "valid driver" do
    assert driver = Driver.new(email: 'email@email.com')
    assert_not driver.valid?
    assert_equal ["can't be blank"], driver.errors[:first_name]
  end
end
