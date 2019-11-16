require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test "valid location" do
    assert location = Location.new
    assert_not location.valid?
    assert_equal ["can't be blank"], location.errors[:address]
  end
end
