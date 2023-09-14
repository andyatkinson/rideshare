#  Implementation of:
#  https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/
#
#  - Do not use the 'public' schema
#  - Create a owner role and then create readwrite and readonly roles within that
#  - Use a password and set things like statement_timeout even for local use
#
# 1. Generate password: `openssl rand -base64 16`
# 1. touch ~/.pgpass
# 1. chmod 0600 ~/.pgpass
# 1. Edit ~/.pgpass and place password value in
# 1. export PG_ROLE_PASSWORD=the_password
#
# localhost:5432:rideshare_development:rideshare_admin:<from above>
#

export DB_URL=postgres://postgres:@localhost:5432/postgres # run as OS user/superuser/admin
export APP_DB_NAME=rideshare_development
export APP_ROLE=rideshare_admin
export REPL_ROLE=repl # for replication
export RIDESHARE_DB_URL=postgres://rideshare_admin:@localhost:5432/rideshare_development

echo "%%%%%%%%%%%"
echo "Rideshare main app DB"
echo "%%%%%%%%%%%"

# ROLES
echo "SELECT 'CREATE USER $APP_ROLE WITH LOGIN ENCRYPTED PASSWORD "$PG_ROLE_PASSWORD"' WHERE NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$APP_ROLE')\gexec" | psql $DB_URL
echo "SELECT 'CREATE USER $REPL_ROLE WITH LOGIN ENCRYPTED PASSWORD "$PG_ROLE_PASSWORD"' WHERE NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$REPL_ROLE')\gexec" | psql $DB_URL

# APP DB
# Credit: https://stackoverflow.com/a/56040183/126688
echo "Creating datbase $APP_DB_NAME"
echo "SELECT 'CREATE DATABASE $APP_DB_NAME' WHERE NOT EXISTS (SELECT datname FROM pg_database WHERE datname = '$APP_DB_NAME')\gexec" | psql $DB_URL;
psql $DB_URL -c "ALTER DATABASE $APP_DB_NAME OWNER TO $APP_ROLE"

# CONNECT
psql $DB_URL -c "GRANT CONNECT ON DATABASE $APP_DB_NAME TO $APP_ROLE"

# PRIVILEGES
psql $DB_URL -c "ALTER DEFAULT PRIVILEGES FOR ROLE $APP_ROLE GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $APP_ROLE"
psql $DB_URL -c "ALTER DEFAULT PRIVILEGES FOR ROLE $APP_ROLE GRANT USAGE, SELECT ON SEQUENCES TO $APP_ROLE"

# SCHEMA
psql $RIDESHARE_DB_URL -c "CREATE SCHEMA IF NOT EXISTS $APP_ROLE AUTHORIZATION $APP_ROLE"

# SCHEMA scoped GRANTS
echo "Grants"
psql $RIDESHARE_DB_URL -c "GRANT USAGE, CREATE ON SCHEMA $APP_ROLE TO $APP_ROLE"
psql $RIDESHARE_DB_URL -c "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA $APP_ROLE TO $APP_ROLE"
psql $DB_URL -c "ALTER USER $APP_ROLE CREATEDB" # for bin/rails test and bin/rails db:reset

# SCHEMA scoped SEQUENCES
psql $RIDESHARE_DB_URL -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA $APP_ROLE TO $APP_ROLE"

# SCHEMA scoped EXTENSIONS - Enable these with a superuser
psql $DB_URL -c "CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA $APP_ROLE"
psql $DB_URL -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA $APP_ROLE"

# Load test script
sh scripts/setup_db_test.sh
