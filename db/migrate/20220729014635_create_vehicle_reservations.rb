class CreateVehicleReservations < ActiveRecord::Migration[7.0]

  # https://wiki.postgresql.org/wiki/Don%27t_Do_This#Don.27t_use_timestamp_.28without_time_zone.29
  # https://discuss.rubyonrails.org/t/postgres-timestampz-by-default-in-rails-6-2/76537
  #
  # db/schema.rb does not seem to capture the timestamptz column type
  # https://blog.appsignal.com/2020/01/15/the-pros-and-cons-of-using-structure-sql-in-your-ruby-on-rails-application.html
  #
  def change
    create_table :vehicle_reservations do |t|
      t.integer :vehicle_id, null: false, index: true
      t.integer :trip_request_id, null: false
      t.boolean :canceled, null: false, default: false
      t.timestamptz :starts_at, null: false
      t.timestamptz :ends_at, null: false

      t.timestamps
    end
  end
end
