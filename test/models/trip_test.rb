require 'test_helper'

class TripTest < ActiveSupport::TestCase
  setup do
    @trip = trips(:completed_trip)
  end

  test "rating values with valid values" do
    @trip.rating = 1
    assert @trip.valid?

    @trip.rating = 5
    assert @trip.valid?
  end

  test "rating values with invalid values" do
    @trip.rating = 0
    assert_not @trip.valid?
    assert_equal ["must be greater than or equal to 1"], @trip.errors[:rating]

    @trip.rating = 6
    assert_not @trip.valid?
    assert_equal ["must be less than or equal to 5"], @trip.errors[:rating]

    @trip.rating = 2.5
    assert_not @trip.valid?
    assert_equal ["must be an integer"], @trip.errors[:rating]
  end

  test "rating requires a completed trip" do
    @incomplete_trip = trips(:incomplete_trip)
    @incomplete_trip.rating = 5

    assert_not @incomplete_trip.valid?
    assert_equal ["must be completed before a rating can be added"], @incomplete_trip.errors[:rating]
  end
end
