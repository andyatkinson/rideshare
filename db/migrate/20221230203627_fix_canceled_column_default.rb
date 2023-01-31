class FixCanceledColumnDefault < ActiveRecord::Migration[7.1]
  def change
    # by default, reservations should be canceled=false
    change_column_default :vehicle_reservations, :canceled, false
  end
end
