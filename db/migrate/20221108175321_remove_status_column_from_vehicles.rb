class RemoveStatusColumnFromVehicles < ActiveRecord::Migration[7.0]
  def change
    # removing this to replace it with a DB enum
    # NOTE: if this was in production, do not immediately
    # drop this column, but create a new one to begin using
    # migrate to, and then retire the old column
    safety_assured do
      remove_column :vehicles, :status
    end
  end
end
