require 'test_helper'

class Api::TripsControllerTest < ActionDispatch::IntegrationTest
  test "GET to index works" do
    get api_trips_url
    assert_response 200
    assert_equal 3, response.parsed_body.size
  end

  test "searching by start location works" do
    get api_trips_url, params: { start_location: "New York" }
    assert_response 200
    assert_equal 2, response.parsed_body.size
  end

  test "searching by driver name works" do
    get api_trips_url, params: { driver_name: "Jack" }
    assert_response 200
    assert_equal 1, response.parsed_body.size
  end

  test "searching by start location and rider name works" do
    get api_trips_url, params: { start_location: "JFK", rider_name: "Jessica" }
    assert_response 200
    assert_equal 1, response.parsed_body.size
  end

  test "show a single trip" do
    get api_trip_url(trip)
    assert_response 200
    assert_equal trip.id, response.parsed_body['id']
  end

  ### API: /my ###
  test "get my trips" do
    get my_api_trips_url,
      headers: { 'Authorization' => auth_token },
      params: { rider_id: trip.rider.id }
    assert_response 200
    assert json = JSON.parse(response.body)

    assert first_trip = json['data'][0]
    assert_equal 'Jane D.', first_trip['attributes']['rider_name']
    assert_equal 'Meg W.', first_trip['attributes']['driver_name']
  end

  test "get my trips sparse fieldset all fields" do
    get my_api_trips_url,
      headers: { 'Authorization' => auth_token },
      params: { rider_id: trip.rider.id, "fields[trips]" => "rider_name,driver_name" }
    assert_response 200
    assert json = JSON.parse(response.body)

    assert first_trip = json['data'][0]
    assert_equal "Jane D.", first_trip['attributes']['rider_name']
    assert_equal "Meg W.", first_trip['attributes']['driver_name']
  end

  test "get my trips sparse fieldset subset of fields" do
    get my_api_trips_url,
      headers: { 'Authorization' => auth_token },
      params: { rider_id: trip.rider.id, "fields[trips]" => "rider_name" }
    assert_response 200
    assert json = JSON.parse(response.body)

    assert first_trip = json['data'][0]
    assert_equal "Jane D.", first_trip['attributes']['rider_name']
    assert_nil first_trip['attributes']['driver_name']
  end

  test "get my trips no auth token" do
    get my_api_trips_url,
      params: { rider_id: trip.rider.id }
    assert_response 401
  end

  test "get trip details" do
    get details_api_trip_url(id: trip.id)
    assert_response 200
    assert json = JSON.parse(response.body)
    assert json.has_key?('data')
    assert_equal 'trip', json['data']['type']
  end

  test "get trip details with driver fields as compound document" do
    get details_api_trip_url(id: trip.id), params: {include: "driver"}
    assert_response 200
    assert json = JSON.parse(response.body)
    assert json.has_key?('data')
    assert_equal 'trip', json['data']['type']

    assert json.has_key?('included')
    assert driver_details = json['included'][0]['attributes']

    assert driver_details.has_key?('display_name')
    assert driver_details.has_key?('average_rating')
  end

  test "get trip details with driver fields as compound document with sparse fieldset on driver" do
    get details_api_trip_url(id: trip.id),
      params: { include: "driver", "fields[driver]" => "average_rating" }

    assert_response 200
    assert json = JSON.parse(response.body)
    assert json.has_key?('data')
    assert_equal 'trip', json['data']['type']

    assert json.has_key?('included')
    assert driver_details = json['included'][0]['attributes']

    assert driver_details.has_key?('average_rating')

    assert_not driver_details.has_key?('display_name'),
      "did not expect display_name for driver to be included"
  end

  private

  def trip
    @trip ||= trips(:completed_trip)
  end

  def auth_token
    JsonWebToken.encode(user_id: trip.rider.id)
  end
end
