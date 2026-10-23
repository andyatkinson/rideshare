require 'test_helper'

class PgdogTripPositionsTest < ActiveSupport::TestCase
  test 'position writes route through PgDog while trip associations use primary' do
    trip = trips(:completed_trip)
    position = trip.trip_positions.create!(position: '(1,2)')

    assert_equal trip, position.reload.trip
    assert_includes trip.trip_positions.reload.map(&:id), position.id
    assert_match(/\A[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/, position.id)
    assert_includes Trip.preload(:trip_positions).find(trip.id).trip_positions.map(&:id), position.id

    PgdogRecord.connected_to(role: :reading) do
      assert_equal position.id, TripPosition.for_trip(trip.id).find(position.id).id
    end
  ensure
    TripPosition.where(trip_id: trip.id, id: position.id).delete_all if position&.persisted?
  end

  test 'trip filtering uses two SELECTs because joining trips on PgDog fails' do
    completed = trips(:completed_trip)
    rated = trips(:rated_trip)
    incomplete = trips(:incomplete_trip)
    positions = [completed, rated, incomplete].map do |trip|
      trip.trip_positions.create!(position: '(1,2)')
    end

    # Isolate the deliberately invalid SQL from Rails' fixture transactions.
    join_sql = TripPosition.joins(:trip).where(trip_id: completed.id).to_sql
    PG.connect(PgdogRecord.connection_db_config.url) do |connection|
      error = assert_raises(PG::UndefinedTable) { connection.exec(join_sql) }
      assert_match(/relation "trips" does not exist/, error.message)
    end

    queries = []
    subscriber = lambda do |*args|
      event = args.last
      queries << event[:sql] if event[:sql].match?(/\ASELECT .*FROM "(?:trips|trip_positions)"/m)
    end
    result = ActiveSupport::Notifications.subscribed(subscriber, 'sql.active_record') do
      TripPosition.for_trips(Trip.completed.where(id: [completed.id, rated.id, incomplete.id])).to_a
    end

    assert_equal positions.first(2).map(&:id), result.map(&:id)
    assert_equal 2, queries.size
    assert_match(/FROM "trips"/, queries.first)
    assert_match(/FROM "trip_positions"/, queries.last)
    assert_no_match(/JOIN|SELECT.*SELECT/m, queries.last)
  ensure
    positions&.each do |position|
      TripPosition.where(trip_id: position.trip_id, id: position.id).delete_all
    end
  end

  test 'reading role rejects position writes' do
    PgdogRecord.connected_to(role: :reading) do
      assert_raises(ActiveRecord::ReadOnlyError) do
        TripPosition.where(trip_id: trips(:completed_trip).id).delete_all
      end
    end
  end
end
