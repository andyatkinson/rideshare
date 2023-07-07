require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test "valid location" do
    assert location = Location.new
    assert_not location.valid?
    assert !location.errors[:address].include?("be blank")
  end
end
