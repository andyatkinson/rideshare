class CreateVehicleReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicle_reservations do |t|
      t.integer :vehicle_id, null: false, index: true
      t.integer :trip_request_id, null: false
      t.timestamp :starts_at, null: false
      t.timestamp :ends_at, null: false

      t.timestamps
    end
  end
end
