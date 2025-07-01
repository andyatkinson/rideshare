class CreateSlottedCounters < ActiveRecord::Migration[7.2]
  def change
    create_table :slotted_counters do |t|
      t.string :counter_name, null: false
      t.string :associated_record_type, null: false
      t.integer :associated_record_id, null: false
      t.integer :slot, null: false
      t.integer :count, null: false

      t.timestamps
    end

    add_index :slotted_counters, [:associated_record_id, :associated_record_type, :counter_name, :slot], unique: true, name: 'index_slotted_counters'
  end
end
