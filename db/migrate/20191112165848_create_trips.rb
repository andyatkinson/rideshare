class CreateTrips < ActiveRecord::Migration[6.0]
  def change
    # Indexes: Rails adds PK index
    create_table :trips do |t|
      t.integer :trip_request_id, index: true, null: false # index: FK
      t.integer :driver_id, index: true, null: false # index: FK
      t.timestamp :completed_at # nullable
      t.integer :rating, index: true # index: aggregate queries

      t.timestamps # Rails adds null: false
    end
  end
end
