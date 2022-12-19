require 'test_helper'

class Api::TripRequestsControllerTest < ActionDispatch::IntegrationTest
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

  test "SHOW status for trip_request" do
    trip_request = trip_requests(:big_trip)
    get api_trip_request_url(trip_request)
    assert_response 200
    assert response.parsed_body['trip_request_id'].present?
    assert response.parsed_body['trip_id'].present?
  end
end
