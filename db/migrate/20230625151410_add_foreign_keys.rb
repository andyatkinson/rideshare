class AddForeignKeys < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      add_foreign_key :trip_positions, :trips

      add_foreign_key :vehicle_reservations, :vehicles

      add_foreign_key :trip_requests, :users, column: :rider_id
    end
  end
end
