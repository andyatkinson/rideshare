class CreateTripRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :trip_requests do |t|
      t.integer :rider_id, null: false
      t.integer :start_location_id, null: false
      t.integer :end_location_id, null: false

      t.timestamps
    end
  end
end
