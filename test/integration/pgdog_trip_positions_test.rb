require 'test_helper'

class PgdogTripPositionsTest < ActiveSupport::TestCase
  test 'position writes route through PgDog while trip associations use primary' do
    trip = trips(:completed_trip)
    position = trip.trip_positions.create!(position: '(1,2)')

    assert_equal trip, position.reload.trip
    assert_includes trip.trip_positions.reload.map(&:id), position.id
    assert_match(/\A[0-9a-f-]{36}\z/, position.id)
    assert_includes Trip.preload(:trip_positions).find(trip.id).trip_positions.map(&:id), position.id

    PgdogRecord.connected_to(role: :reading) do
      assert_equal position.id, TripPosition.for_trip(trip.id).find(position.id).id
    end
  ensure
    TripPosition.where(trip_id: trip.id, id: position.id).delete_all if position&.persisted?
  end

  test 'reading role rejects position writes' do
    PgdogRecord.connected_to(role: :reading) do
      assert_raises(ActiveRecord::ReadOnlyError) do
        TripPosition.where(trip_id: trips(:completed_trip).id).delete_all
      end
    end
  end
end
