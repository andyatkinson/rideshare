export DB_URL=postgres://postgres:@localhost:5432/postgres # run as OS user/superuser/admin
export APP_TEST_DB_NAME=rideshare_test
export APP_TEST_USER=rideshare_user
export APP_SCHEMA_NAME=rideshare_schema
export TEST_DB_URL=postgres://postgres:@localhost:5432/rideshare_test # run as OS user/superuser/admin

echo "%%%%%%%%%%%"
echo "Test DB"
echo "%%%%%%%%%%%"

# ROLES
echo "SELECT 'CREATE USER $APP_TEST_USER' WHERE NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$APP_TEST_USER')\gexec" | psql $DB_URL


echo "Creating database $APP_TEST_DB_NAME"
echo "SELECT 'CREATE DATABASE $APP_TEST_DB_NAME' WHERE NOT EXISTS (SELECT datname FROM pg_database WHERE datname = '$APP_TEST_DB_NAME')\gexec" | psql $DB_URL;
psql $DB_URL -c "ALTER DATABASE $APP_TEST_DB_NAME OWNER TO $APP_TEST_USER"

# SUPERUSER ONLY(!) for rideshare_test database test user
# SUPERUSER required to drop all Foreign Key Constraints, which is done when truncating tables
# https://stackoverflow.com/a/32213455/126688
psql $DB_URL -c "ALTER USER $APP_TEST_USER WITH SUPERUSER"

# CONNECT
psql $DB_URL -c "GRANT CONNECT ON DATABASE $APP_TEST_DB_NAME TO $APP_TEST_USER;"

# SCHEMA
psql $DB_URL -c "CREATE SCHEMA IF NOT EXISTS $APP_SCHEMA_NAME"

# SEARCH PATH
psql $TEST_DB_URL -c "ALTER DATABASE $APP_TEST_DB_NAME SET SEARCH_PATH TO $APP_SCHEMA_NAME"
