# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_11_015524) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "intarray"
  enable_extension "pg_cron"
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", precision: nil
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "address", null: false, comment: "Postal style address as text"
    t.decimal "latitude", precision: 15, scale: 10, null: false
    t.decimal "longitude", precision: 15, scale: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_locations_on_address"
    t.index ["latitude"], name: "index_locations_on_latitude"
    t.index ["longitude"], name: "index_locations_on_longitude"
  end

  create_table "trip_requests", force: :cascade do |t|
    t.integer "rider_id", null: false
    t.integer "start_location_id", null: false
    t.integer "end_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_location_id"], name: "index_trip_requests_on_end_location_id"
    t.index ["rider_id"], name: "index_trip_requests_on_rider_id"
    t.index ["start_location_id"], name: "index_trip_requests_on_start_location_id"
  end

  create_table "trips", id: false, comment: "Store rider trips here", force: :cascade do |t|
    t.bigserial "id", null: false
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "trips_driver_id_idx"
    t.index ["driver_id"], name: "trips_driver_id_idx1"
    t.index ["driver_id"], name: "trips_driver_id_idx2"
    t.index ["driver_id"], name: "trips_intermediate_driver_id_idx"
    t.index ["rating"], name: "trips_intermediate_rating_idx", where: "(rating IS NULL)"
    t.index ["rating"], name: "trips_rating_idx", where: "(rating IS NULL)"
    t.index ["rating"], name: "trips_rating_idx1", where: "(rating IS NULL)"
    t.index ["rating"], name: "trips_rating_idx2", where: "(rating IS NULL)"
  end

  create_table "trips_202111", id: :bigint, default: -> { "nextval('trips_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "trips_202111_driver_id_idx"
    t.index ["rating"], name: "trips_202111_rating_idx", where: "(rating IS NULL)"
  end

  create_table "trips_202201", id: :bigint, default: -> { "nextval('trips_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "trips_202201_driver_id_idx"
    t.index ["rating"], name: "trips_202201_rating_idx", where: "(rating IS NULL)"
  end

  create_table "trips_202202", id: :bigint, default: -> { "nextval('trips_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "trips_202202_driver_id_idx"
    t.index ["rating"], name: "trips_202202_rating_idx", where: "(rating IS NULL)"
  end

  create_table "trips_202203", id: :bigint, default: -> { "nextval('trips_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "trips_202203_driver_id_idx"
    t.index ["rating"], name: "trips_202203_rating_idx", where: "(rating IS NULL)"
  end

  create_table "trips_202204", id: :bigint, default: -> { "nextval('trips_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "trips_202204_driver_id_idx"
    t.index ["rating"], name: "trips_202204_rating_idx", where: "(rating IS NULL)"
  end

  create_table "trips_202205", id: :bigint, default: -> { "nextval('trips_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "trips_202205_driver_id_idx"
    t.index ["rating"], name: "trips_202205_rating_idx", where: "(rating IS NULL)"
  end

  create_table "trips_202206", id: false, force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('trips_id_seq'::regclass)" }, null: false
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips_intermediate", id: false, comment: "column:created_at,period:month,cast:date,version:3", force: :cascade do |t|
    t.bigint "id", default: -> { "nextval('trips_id_seq'::regclass)" }, null: false
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips_retired", id: :bigint, default: -> { "nextval('trips_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "trip_request_id", null: false
    t.integer "driver_id", null: false
    t.datetime "completed_at", precision: nil
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_trips_on_driver_id"
    t.index ["rating"], name: "index_trips_on_rating_partial", where: "(rating IS NULL)"
  end

  create_table "users", comment: "sensitive_fields|first_name:scrub_text,last_name:scrub_text,email:scrub_email", force: :cascade do |t|
    t.string "first_name", null: false, comment: "sensitive_data=true"
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "trip_requests", "locations", column: "end_location_id"
  add_foreign_key "trip_requests", "locations", column: "start_location_id"
  add_foreign_key "trip_requests", "users", column: "rider_id"
  add_foreign_key "trips", "trip_requests", name: "trips_intermediate_trip_request_id_fkey"
  add_foreign_key "trips", "users", column: "driver_id", name: "trips_intermediate_driver_id_fkey"
  add_foreign_key "trips_202111", "trip_requests", name: "trips_intermediate_trip_request_id_fkey"
  add_foreign_key "trips_202111", "users", column: "driver_id", name: "trips_intermediate_driver_id_fkey"
  add_foreign_key "trips_202201", "trip_requests", name: "trips_intermediate_trip_request_id_fkey"
  add_foreign_key "trips_202201", "users", column: "driver_id", name: "trips_intermediate_driver_id_fkey"
  add_foreign_key "trips_202202", "trip_requests", name: "trips_intermediate_trip_request_id_fkey"
  add_foreign_key "trips_202202", "users", column: "driver_id", name: "trips_intermediate_driver_id_fkey"
  add_foreign_key "trips_202203", "trip_requests", name: "trips_intermediate_trip_request_id_fkey"
  add_foreign_key "trips_202203", "users", column: "driver_id", name: "trips_intermediate_driver_id_fkey"
  add_foreign_key "trips_202204", "trip_requests", name: "trips_intermediate_trip_request_id_fkey"
  add_foreign_key "trips_202204", "users", column: "driver_id", name: "trips_intermediate_driver_id_fkey"
  add_foreign_key "trips_202205", "trip_requests", name: "trips_intermediate_trip_request_id_fkey"
  add_foreign_key "trips_202205", "users", column: "driver_id", name: "trips_intermediate_driver_id_fkey"
  add_foreign_key "trips_202206", "trip_requests", name: "trips_intermediate_trip_request_id_fkey1"
  add_foreign_key "trips_202206", "users", column: "driver_id", name: "trips_intermediate_driver_id_fkey1"
  add_foreign_key "trips_intermediate", "trip_requests", name: "trips_intermediate_trip_request_id_fkey1"
  add_foreign_key "trips_intermediate", "users", column: "driver_id", name: "trips_intermediate_driver_id_fkey1"
  add_foreign_key "trips_retired", "trip_requests"
  add_foreign_key "trips_retired", "users", column: "driver_id"
  create_function :scrub_email, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.scrub_email(email_address character varying)
       RETURNS character varying
       LANGUAGE plpgsql
      AS $function$
      BEGIN
      RETURN
        -- take random MD5 text that is the same
        -- length as the first part of the email address
        -- EXCEPT when it's less than 5 chars, since we might
        -- have a collision. In that case use 5: greatest(length,6)
        CONCAT(
          substr(
            md5(random()::text),
            0,
            greatest(length(split_part(email_address, '@', 1)) + 1, 6)
          ),
          '@',
          split_part(email_address, '@', 2)
        );
      END;
      $function$
  SQL
  create_function :scrub_text, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.scrub_text(text character varying)
       RETURNS character varying
       LANGUAGE plpgsql
      AS $function$
      BEGIN
      RETURN
        -- replace from position 0, to max(length or 6)
        substr(
          md5(random()::text),
          0,
          greatest(length(text) + 1, 6)
        );
      END;
      $function$
  SQL


  create_trigger :cron_job_cache_invalidate, sql_definition: <<-SQL
      CREATE TRIGGER cron_job_cache_invalidate AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE ON cron.job FOR EACH STATEMENT EXECUTE FUNCTION cron.job_cache_invalidate()
  SQL
end
