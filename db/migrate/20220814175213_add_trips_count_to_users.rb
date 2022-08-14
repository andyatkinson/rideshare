class AddTripsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :trips_count, :integer
  end
end
