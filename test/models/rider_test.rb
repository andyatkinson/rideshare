require 'test_helper'

class RiderTest < ActiveSupport::TestCase
  test "valid rider" do
    assert rider = Rider.new(email: 'email@email.com')
    assert_not rider.valid?
    assert_equal ["can't be blank"], rider.errors[:first_name]
  end
end
