class AddStatusColumnToVehicles < ActiveRecord::Migration[7.0]
  def change
    add_column :vehicles, :status, :string,
      null: false,
      default: VehicleStatus::DRAFT
  end
end
