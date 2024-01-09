#!/bin/bash


# Set each of these:
# Or use existing value for RIDESHARE_DB_PASSWORD from ~/.pgpass
#
# export RIDESHARE_DB_PASSWORD=$(openssl rand -hex 12)
export DB_URL="postgres://postgres:@localhost:5432/postgres"
export DATABASE_URL="postgres://owner:@localhost:5432/rideshare_development"

# Check if the environment variable DB_URL is set
if [ -z "$DB_URL" ]; then
    echo "Error: DB_URL is not set."
    echo
    echo "See: db/setup.sh"
    echo "Run: export DB_URL='postgres://postgres:@localhost:5432/postgres'"
    exit 1
fi
if [ -z "$RIDESHARE_DB_PASSWORD" ]; then
    echo "Error: RIDESHARE_DB_PASSWORD is not set."
    echo
    echo "Check for existing value in ~/.pgpass"
    echo 'e.g. export RIDESHARE_DB_PASSWORD="HSnDDgFtyW9fyFI"'
    echo "OR generate new value (See: db/setup.sh)"
    exit 1
fi

# roles
psql $DB_URL -v password_to_save=$RIDESHARE_DB_PASSWORD -a -f db/create_role_owner.sql
psql $DB_URL -a -f db/create_role_readwrite_users.sql
psql $DB_URL -a -f db/create_role_readonly_users.sql
psql $DB_URL -v password_to_save=$RIDESHARE_DB_PASSWORD -a -f db/create_role_app_user.sql
psql $DB_URL -v password_to_save=$RIDESHARE_DB_PASSWORD -a -f db/create_role_app_readonly.sql

# database
psql $DB_URL -a -f db/create_database.sql

# revoke all on public, drop public schema
psql $DB_URL -a -f db/revoke_drop_public_schema.sql

# schema
psql $DB_URL -a -f db/create_schema.sql

# grants
psql $DB_URL -a -f db/create_grants_database.sql
psql $DB_URL -a -f db/create_grants_schema.sql

# alter defaults
psql $DB_URL -a -f db/alter_default_privileges_readwrite.sql
psql $DB_URL -a -f db/alter_default_privileges_readonly.sql
psql $DB_URL -a -f db/alter_default_privileges_public.sql

echo "Add to ~/.pgpass"
echo "localhost:5432:rideshare_development:owner:$RIDESHARE_DB_PASSWORD
localhost:6432:rideshare_development:owner:$RIDESHARE_DB_PASSWORD
localhost:5432:rideshare_development:app:$RIDESHARE_DB_PASSWORD
localhost:54321:rideshare_development:owner:$RIDESHARE_DB_PASSWORD
localhost:54322:rideshare_development:owner:$RIDESHARE_DB_PASSWORD
*:*:*:replication_user:$RIDESHARE_DB_PASSWORD
*:*:*:app_readonly:$RIDESHARE_DB_PASSWORD" >> ~/.pgpass

echo "chmod ~/.pgpass"
chmod 0600 ~/.pgpass

echo
echo "DONE! 🎉"
echo "Notes:"
echo "Make sure graphviz is installed: 'brew install graphviz'"
echo
echo "Next: run 'bin/rails db:migrate' to apply pending migrations"
echo
echo "If you ran as: 'sh db/setup.sh 2>&1 | tee -a output.log'"
echo "Review 'output.log' for any errors"
echo
echo "~/.pgpass received changes."

echo "Set DATABASE URL, which you can find in .env"
echo "Run: export $(cat .env|grep DATABASE_URL|head -n1)"
