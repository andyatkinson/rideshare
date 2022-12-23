class CreateTripPositions < ActiveRecord::Migration[7.1]
  def change
    create_table :trip_positions do |t|
      t.point :position
      t.bigint :trip_id, null: false

      t.timestamps
    end

    # Skipping FK for now since a lot of data will be inserted,
    # preferring faster inserts. `trip_id` would also likely
    # be indexed.
    #
    # new table, so skipping safety checks
    # safety_assured do
    #   add_foreign_key :trip_positions, :trips
    # end
  end
end
