class AddConstraintsLocationsState < ActiveRecord::Migration[7.1]
  def change
    # I've verified all the locations have a 2-char state
    # This opts out of Strong Migrations checks
    safety_assured do
      change_column_null(:locations, :state, false)
    end

    # Opt-out of Strong Migrations checks
    safety_assured do
      add_check_constraint :locations,
        "LENGTH(state) = 2",
        name: "state_length_check",
        validate: true
    end
  end
end
