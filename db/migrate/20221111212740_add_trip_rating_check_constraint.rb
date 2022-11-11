class AddTripRatingCheckConstraint < ActiveRecord::Migration[7.0]
  def change
   add_check_constraint :trips,
     "rating IS NULL OR (rating >= 1 AND rating <= 5)",
     name: "rating_check",
     validate: false
  end
end
