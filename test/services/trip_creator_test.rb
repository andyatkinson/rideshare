require 'test_helper'

class TripCreatorTest < ActiveSupport::TestCase
  test "can create trip" do
    driver = drivers(:jack) # at least one exists
    trip_request = trip_requests(:big_trip)

    trip_creator = TripCreator.new(
      trip_request_id: trip_request.id
    )

    assert_difference -> { Trip.count }, +1 do
      trip_creator.create_trip!
    end
  end
end
