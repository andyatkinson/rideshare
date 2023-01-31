class AddStatusColumnDbEnumTypeToVehicles < ActiveRecord::Migration[7.0]
  def change
    create_enum :vehicle_status, [
      VehicleStatus::DRAFT,
      VehicleStatus::PUBLISHED
    ]

    add_column :vehicles, :status, :enum,
      enum_type: :vehicle_status,
      default: VehicleStatus::DRAFT,
      null: false
  end
end
