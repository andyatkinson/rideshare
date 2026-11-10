require 'test_helper'

class TripCreatorTest < ActiveSupport::TestCase
  setup do
    @request = TripRequest.create!(rider: riders(:jessica), start_location: locations(:bos), end_location: locations(:nyc))
  end

  test 'can create a trip using an idle driver' do
    trip = nil
    assert_difference -> { Trip.count }, 1 do
      trip = TripCreator.new(trip_request_id: @request.id).create_trip!
    end
    assert_equal drivers(:meg).id, trip.driver_id
    assert_not Driver.idle.exists?(trip.driver_id)
  end

  test 'same request is not assigned twice' do
    creator = TripCreator.new(trip_request_id: @request.id)
    trip = creator.create_trip!
    assert_no_difference -> { Trip.count } do
      assert_equal trip.id, creator.create_trip!.id
    end
  end

  test 'busy drivers are excluded and driver pool is respected' do
    assert_no_difference -> { Trip.count } do
      assert_raises(TripCreator::NoAvailableDriver) do
        TripCreator.new(trip_request_id: @request.id, driver_ids: [drivers(:jack).id]).create_trip!
      end
    end
  end

  test 'completed driver becomes available again' do
    trip = TripCreator.new(trip_request_id: @request.id, driver_ids: [drivers(:meg).id]).create_trip!
    trip.update!(completed_at: Time.current)
    assert Driver.idle.exists?(trip.driver_id)
  end
end
