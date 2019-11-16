require 'test_helper'

class TripRequestTest < ActiveSupport::TestCase
  test "trip request works" do
    trip_request = trip_requests(:airport_trip)
    assert trip_request.trip.present?
    assert trip_request.start_location.present?
    assert trip_request.end_location.present?
    assert trip_request.rider.present?
  end
end
