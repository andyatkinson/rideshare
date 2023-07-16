class AddForeignKeyColumnVehicleReservations < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      add_foreign_key :vehicle_reservations, :trip_requests
    end
  end
end
