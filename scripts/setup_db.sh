
# 1. Generate password: `openssl rand -base64 16`
# 1. touch ~/.pgpass
# 1. chmod 0600 ~/.pgpass
# 1. Edit ~/.pgpass
#
# localhost:5432:rideshare_development:rideshare_user:<from above>
#

export DB_URL=postgres://postgres:@localhost:5432/postgres # run as OS user/superuser/admin
export APP_DB_NAME=rideshare_development
export APP_TEST_DB_NAME=rideshare_test
export APP_USER=rideshare_user
export APP_TEST_USER=rideshare_user
export REPL_USER=repl # for replication
export APP_SCHEMA_NAME=rideshare_schema

# ROLES
echo "SELECT 'CREATE USER $APP_USER' WHERE NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$APP_USER')\gexec" | psql $DB_URL
echo "SELECT 'CREATE USER $APP_TEST_USER' WHERE NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$APP_TEST_USER')\gexec" | psql $DB_URL
echo "SELECT 'CREATE USER $REPL_USER' WHERE NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$REPL_USER')\gexec" | psql $DB_URL

# SCHEMA
psql $DB_URL -c "CREATE SCHEMA IF NOT EXISTS $APP_SCHEMA_NAME"

# SEARCH PATH
psql $DB_URL -c "ALTER DATABASE $APP_DB_NAME SET SEARCH_PATH TO $APP_SCHEMA_NAME"
psql $DB_URL -c "ALTER DATABASE $APP_TEST_DB_NAME SET SEARCH_PATH TO $APP_SCHEMA_NAME"

# APP DB
# Credit: https://stackoverflow.com/a/56040183/126688
echo "Creating datbase $APP_DB_NAME"
echo "SELECT 'CREATE DATABASE $APP_DB_NAME' WHERE NOT EXISTS (SELECT datname FROM pg_database WHERE datname = '$APP_DB_NAME')\gexec" | psql $DB_URL;
psql $DB_URL -c "ALTER DATABASE $APP_DB_NAME OWNER TO $APP_USER"

echo "Creating database $APP_TEST_DB_NAME"
echo "SELECT 'CREATE DATABASE $APP_TEST_DB_NAME' WHERE NOT EXISTS (SELECT datname FROM pg_database WHERE datname = '$APP_TEST_DB_NAME')\gexec" | psql $DB_URL;
psql $DB_URL -c "ALTER DATABASE $APP_TEST_DB_NAME OWNER TO $APP_TEST_USER"

# PRIVILEGES
psql $DB_URL -c "ALTER DEFAULT PRIVILEGES FOR ROLE $APP_USER GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $APP_USER;"
psql $DB_URL -c "ALTER DEFAULT PRIVILEGES FOR ROLE $APP_USER GRANT USAGE, SELECT ON SEQUENCES TO $APP_USER;"

# GRANTS
psql $DB_URL -c "GRANT USAGE, CREATE ON SCHEMA public TO $APP_USER;"
psql $DB_URL -c "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA $APP_SCHEMA_NAME TO $APP_USER;"
psql $DB_URL -c "ALTER USER $APP_USER CREATEDB" # for bin/rails test and bin/rails db:reset

# SUPERUSER ONLY(!) for rideshare_test database test user
# SUPERUSER required to drop all Foreign Key Constraints, which is done when truncating tables
# https://stackoverflow.com/a/32213455/126688
psql $DB_URL -c "ALTER USER $APP_TEST_USER WITH SUPERUSER"

# SEQUENCES
psql $DB_URL -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA $APP_SCHEMA_NAME TO $APP_USER;"

# EXTENSIONS - Enable these with a superuser
# GRANT USAGE ON EXTENSION your_extension_name TO your_username;
psql $DB_URL -c "CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA $APP_SCHEMA_NAME"
psql $DB_URL -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA $APP_SCHEMA_NAME"

# FUNCTIONS AND PROCEDURES
psql $DB_URL -c "GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA $APP_SCHEMA_NAME TO $APP_USER;"

# CONNECT
psql $DB_URL -c "GRANT CONNECT ON DATABASE $APP_DB_NAME TO $APP_USER;"
psql $DB_URL -c "GRANT CONNECT ON DATABASE $APP_TEST_DB_NAME TO $APP_TEST_USER;"
