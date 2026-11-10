require 'test_helper'

class UuidPrimaryKeysTest < ActiveSupport::TestCase
  TABLES = %w[users locations vehicles trip_requests trips trip_positions vehicle_reservations].freeze

  test 'converted application keys and references are UUIDs with database v7 defaults' do
    skip 'Generate and apply uuid_conversion to exercise the optional converted schema' unless User.columns_hash.fetch('id').type == :uuid

    TABLES.each do |table|
      columns = ApplicationRecord.connection.columns(table)
      columns.select { |column| column.name == 'id' || column.name.end_with?('_id') }.each do |column|
        assert_equal :uuid, column.type, "#{table}.#{column.name}"
      end
      assert_equal 'uuidv7()', columns.find { |column| column.name == 'id' }.default_function
    end
    vehicle = Vehicle.create!(name: 'UUID default probe', status: 'draft')
    assert_equal 7, ApplicationRecord.connection.select_value("SELECT uuid_extract_version('#{vehicle.id}'::uuid)")
    assert_equal :uuid, Trip.columns_hash.fetch('driver_id').type
    assert_equal riders(:jane).id, trip_requests(:big_trip).rider_id
  end

  test 'reservation exclusion and search views still work with converted keys' do
    reservation = vehicle_reservations(:party_bus)
    assert_raises(ActiveRecord::StatementInvalid) do
      VehicleReservation.transaction(requires_new: true) do
        VehicleReservation.create!(vehicle: reservation.vehicle, trip_request: reservation.trip_request,
                                   starts_at: reservation.starts_at, ends_at: reservation.ends_at)
      end
    end
    other = Vehicle.create!(name: 'Other reservation vehicle', status: 'draft')
    assert VehicleReservation.create!(vehicle: other, trip_request: reservation.trip_request,
                                     starts_at: reservation.starts_at, ends_at: reservation.ends_at).persisted?
    FastSearchResult.refresh
    assert FastSearchResult.where(driver_id: drivers(:meg).id).exists?
    assert ApplicationRecord.connection.select_all('SELECT * FROM search_results').any?
  end

  test 'future UUID tables get a v7 default while explicit defaults are respected' do
    connection = ApplicationRecord.connection
    connection.create_table(:uuid_default_probe, id: :uuid, temporary: true) do |table|
      table.references :vehicle, type: :uuid
    end
    assert_equal 'uuidv7()', connection.columns(:uuid_default_probe).find { |column| column.name == 'id' }.default_function
    assert_equal :uuid, connection.columns(:uuid_default_probe).find { |column| column.name == 'vehicle_id' }.type
    id = connection.select_value('INSERT INTO uuid_default_probe DEFAULT VALUES RETURNING id')
    assert_equal '7', id[14]
    connection.create_table(:uuid_explicit_probe, id: :uuid, default: nil, temporary: true)
    assert_nil connection.columns(:uuid_explicit_probe).first.default_function
  ensure
    connection&.drop_table(:uuid_default_probe, if_exists: true)
    connection&.drop_table(:uuid_explicit_probe, if_exists: true)
  end
end
