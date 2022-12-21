class ChangeColumnTripsTripRequestId < ActiveRecord::Migration[7.1]

  # Purpose: changing int->bigint
  # for FK column trip_requests.trip_id
  # bundle exec rake active_record_doctor
  #
  def change
    # don't do this in prod
    # https://github.com/ankane/strong_migrations#changing-the-type-of-a-column
    safety_assured do
      # not in prod, so just performing it
      change_column :trips, :trip_request_id, :bigint
    end
  end
end
