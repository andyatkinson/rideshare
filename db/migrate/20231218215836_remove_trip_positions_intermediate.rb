class RemoveTripPositionsIntermediate < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      drop_table :trip_positions_intermediate
    end
  end
end
