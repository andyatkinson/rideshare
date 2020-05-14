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

  private

  def trip
    @trip ||= trips(:completed_trip)
  end
end
