class AddDriversLicenseNumberToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :drivers_license_number, :string, limit: 100
  end
end
