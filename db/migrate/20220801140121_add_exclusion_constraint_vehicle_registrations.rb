class AddExclusionConstraintVehicleRegistrations < ActiveRecord::Migration[7.0]
  def change

    # NOTE: Depends on btree_gist extension being created in scripts/db_setup.sh by superuser
    #
    # Prevent overlapping reservations for
    # the same vehicle
    #
    # - vehicle_id is the vehicle being reserved
    # - starts_at is the start time of the reservation
    # - ends_at is the end time of the reservation
    # - a reservation is associated with a trip_request_id
    # - a reservation may be canceled
    safety_assured do
      execute <<-SQL
      ALTER TABLE vehicle_reservations ADD CONSTRAINT non_overlapping_vehicle_registration
      EXCLUDE USING gist (
        int4range(vehicle_id, vehicle_id, '[]') WITH =,
        tstzrange(starts_at, ends_at) WITH &&
      )
      WHERE (not canceled)

      SQL
    end


    # Error: data type integer has no default operator class for access method "gist"
    # #=> Needed to enable the extension
    #
    # Error: PG::InvalidObjectDefinition: ERROR:  functions in index expression must be marked IMMUTABLE
    # #=> Changed from tstzrange operator to tsrange operator, starts_at, ends_at are timestamp columns
    #
    # https://www.cybertec-postgresql.com/en/postgresql-exclude-beyond-unique/
  end
end
