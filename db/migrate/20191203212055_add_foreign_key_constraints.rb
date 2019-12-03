class AddForeignKeyConstraints < ActiveRecord::Migration[6.0]
  def change
    # https://guides.rubyonrails.org/active_record_migrations.html#foreign-keys
    #
    # Strong migrations provides a warning:
    #
    # === Dangerous operation detected #strong_migrations ===
    # New foreign keys are validated by default. This acquires an AccessExclusiveLock,
    # which is expensive on large tables. Instead, validate it in a separate migration
    # with a more agreeable RowShareLock.
    #
    # We could de-couple the introduction of the FK from the validation of it.

    add_foreign_key :trip_requests, :locations, column: :start_location_id, validate: false
    add_foreign_key :trip_requests, :locations, column: :end_location_id, validate: false

    # Because of STI, we want author_id to be a FK to users.id
    add_foreign_key :trip_requests, :users, column: :rider_id, primary_key: :id, validate: false

    add_foreign_key :trips, :trip_requests, validate: false
    add_foreign_key :trips, :users, column: :driver_id, primary_key: :id, validate: false
  end
end
