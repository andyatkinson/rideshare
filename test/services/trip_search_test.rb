require 'test_helper'

class TripSearchTest < ActiveSupport::TestCase
  test "trip search no params works" do
    trip_search = TripSearch.new({})
    assert trip_search.start_location
    assert trip_search.driver_name
    assert trip_search.rider_name
  end

  test "trip search start location params" do
    trip_search = TripSearch.new({start_location: 'JFK'})
    assert trip_search.start_location.count >= 1
  end

  test "trip search driver name" do
    trip_search = TripSearch.new({driver_name: 'Meg'})
    assert trip_search.driver_name.count >= 1
  end

  test "trip search rider name" do
    trip_search = TripSearch.new({rider_name: 'Jane'})
    assert trip_search.rider_name.count >= 1
  end
end
