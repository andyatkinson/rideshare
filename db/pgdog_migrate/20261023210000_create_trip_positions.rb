class CreateTripPositions < ActiveRecord::Migration[7.2]
  def change
    # Adopt the identical table from earlier demo volumes without losing rows.
    create_table :trip_positions, id: :uuid, default: -> { 'gen_random_uuid()' }, if_not_exists: true do |t|
      t.point :position, null: false
      t.bigint :trip_id, null: false
      t.timestamps
    end
    add_index :trip_positions, %i[trip_id created_at], name: 'trip_positions_trip_id_created_at_idx', if_not_exists: true
  end
end
