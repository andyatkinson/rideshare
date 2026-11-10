require 'test_helper'

class Api::TripRequestsControllerTest < ActionDispatch::IntegrationTest
  test 'CREATE a trip request works' do
    rider = riders(:jane)
    trip_request = {
      rider_id: rider.id,
      start_address: 'Boston, MA',
      end_address: 'New York, NY'
    }

    post api_trip_requests_url, params: { trip_request: trip_request }
    assert_response 201
  end

  test 'no idle drivers returns 503 without an orphan request' do
    TripCreator.new(trip_request_id: trip_requests(:girls_night_out).id,
                    driver_ids: [drivers(:meg).id]).create_trip!
    assert_no_difference -> { TripRequest.count } do
      post api_trip_requests_url, params: { trip_request: {
        rider_id: riders(:jessica).id, start_address: 'Boston, MA', end_address: 'New York, NY'
      } }
    end
    assert_response :service_unavailable
    assert_equal 'No idle driver is available', response.parsed_body['error']
  end

  test 'SHOW status for trip_request' do
    trip_request = trip_requests(:big_trip)
    get api_trip_request_url(trip_request)
    assert_response 200
    assert response.parsed_body['trip_request_id'].present?
    assert response.parsed_body['trip_id'].present?
  end
end
