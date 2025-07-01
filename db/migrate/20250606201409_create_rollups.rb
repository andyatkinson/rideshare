class CreateRollups < ActiveRecord::Migration[7.2]
  def change
    create_table :rollups do |t|
      t.string :name, null: false
      t.string :interval, null: false
      t.datetime :time, null: false
      t.jsonb :dimensions, null: false, default: {}
      t.float :value
    end
    add_index :rollups, [:name, :interval, :time, :dimensions], unique: true
  end
end
