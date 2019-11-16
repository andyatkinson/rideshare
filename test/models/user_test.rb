require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user works" do
    driver = drivers(:jack)
    driver.email = "@email.com"
    assert_not driver.valid?
    assert_equal ["is not an email"], driver.errors[:email]
  end
end
