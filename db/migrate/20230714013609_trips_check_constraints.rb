class TripsCheckConstraints < ActiveRecord::Migration[7.1]
  def change
    safety_assured do

      # Add it back with the NULL check, which is unnecessary
      remove_check_constraint :trips, name: "rating_check"

      add_check_constraint :trips,
        "rating >= 1 AND rating <= 5",
        name: "rating_check"

      add_check_constraint :trips,
        "completed_at > created_at",
        validate: false # Some existing data in pre-made dump violates this
    end

  end
end
