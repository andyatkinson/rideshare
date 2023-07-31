class AddNotNullTripPositionsPosition < ActiveRecord::Migration[7.1]
  def change
    # Not on a live system
    safety_assured do
      change_column_null :trip_positions, :position, false
    end
  end
end
