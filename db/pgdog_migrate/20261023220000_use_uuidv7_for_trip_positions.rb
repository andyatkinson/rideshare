class UseUuidv7ForTripPositions < ActiveRecord::Migration[7.2]
  def change
    change_column_default :trip_positions, :id,
                          from: -> { 'gen_random_uuid()' }, to: -> { 'uuidv7()' }
  end
end
