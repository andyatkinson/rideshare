require 'test_helper'

class Api::TripRequestsControllerTest < ActionDispatch::IntegrationTest
  test "GET all trip requests" do
    get api_trip_requests_url
    assert_response 200
  end

  test "CREATE a trip request works" do
    rider = riders(:jane)
    trip_request = {
      rider_id: rider.id,
      start_address: 'Boston, MA',
      end_address: 'New York, NY'
    }

    post api_trip_requests_url, params: {trip_request: trip_request}
    assert_response 201
  end
end
