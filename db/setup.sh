#!/bin/bash


# Set each of these:
# Or use existing value for RIDESHARE_DB_PASSWORD from ~/.pgpass
#
# export RIDESHARE_DB_PASSWORD=$(openssl rand -hex 12)
# export DB_URL="postgres://postgres:@localhost:5432/postgres"

# Check if the environment variable DB_URL is set
if [ -z "$DB_URL" ]; then
    echo "Error: DB_URL is not set."
    exit 1
fi
if [ -z "$RIDESHARE_DB_PASSWORD" ]; then
    echo "Error: RIDESHARE_DB_PASSWORD is not set."
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
