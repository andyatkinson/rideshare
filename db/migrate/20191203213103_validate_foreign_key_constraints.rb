class ValidateForeignKeyConstraints < ActiveRecord::Migration[6.0]
  def change
    # https://github.com/ankane/strong_migrations#good-5
    validate_foreign_key :trip_requests, :locations, column: :start_location_id
    validate_foreign_key :trip_requests, :locations, column: :end_location_id

    validate_foreign_key :trip_requests, :users, column: :rider_id, primary_key: :id

    validate_foreign_key :trips, :trip_requests
    validate_foreign_key :trips, :users, column: :driver_id, primary_key: :id
  end
end
