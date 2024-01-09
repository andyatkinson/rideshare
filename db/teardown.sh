export DB_URL="postgres://postgres:@localhost:5432/postgres"

psql $DB_URL -c "DROP DATABASE IF EXISTS rideshare_development"
psql $DB_URL -c "DROP DATABASE IF EXISTS rideshare_test"

# https://stackoverflow.com/a/54078230/126688
psql $DB_URL -a -f db/teardown_remove_default_privileges.sql

psql $DB_URL -c "DROP ROLE IF EXISTS owner"
psql $DB_URL -c "DROP ROLE IF EXISTS readwrite_users"
psql $DB_URL -c "DROP ROLE IF EXISTS readonly_users"
psql $DB_URL -c "DROP ROLE IF EXISTS app"
psql $DB_URL -c "DROP ROLE IF EXISTS app_readonly"
