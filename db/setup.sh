#!/bin/bash

# NOTE: This script expects you've generated a password.
# You can do that using "openssl" as follows, or you could use any password
# generation mechanism you like.
#
# Generate a password value using "openssl":
# openssl rand -hex 12
#
# Generate and assign the value to RIDESHARE_DB_PASSWORD:
# export RIDESHARE_DB_PASSWORD=$(openssl rand -hex 12)
#
# Later, you'll create the special password file ~/.pgpass, and
# place your generated password in it.
#
# COMPATIBILITY: Requires PostgreSQL 16
# ENV VARS: [DB_URL, RIDESHARE_DB_PASSWORD]

# Make sure password is set
if [ -z "$RIDESHARE_DB_PASSWORD" ]; then
    echo "Error: 'RIDESHARE_DB_PASSWORD' not set, can't continue."
    echo
    echo "Check for an existing value in file: ~/.pgpass"
    echo "If there's a value, set it like this:"
    echo 'export RIDESHARE_DB_PASSWORD="HSnDDgFtyW9fyFI"'
    echo "OR generate a new value (See comments in: db/setup.sh)"
    exit 1
fi
# Check if the environment variable DB_URL is set
if [ -z "$DB_URL" ]; then
    echo "Error: 'DB_URL' not set, can't continue."
    echo "This is the connection to your instance, using a superuser like 'postgres'."
    echo "The password for 'postgres' is also 'postgres'"
    echo "Connect to the 'postgres' database to issue these commands"
    echo
    echo "See: db/setup.sh"
    echo "Run: export DB_URL='postgres://postgres:@localhost:5432/postgres'"
    exit 1
fi

# Set up Roles and Users on your PostgreSQL instance
psql $DB_URL -v password_to_save=$RIDESHARE_DB_PASSWORD -a -f db/create_role_owner.sql
psql $DB_URL -a -f db/create_role_readwrite_users.sql
psql $DB_URL -a -f db/create_role_readonly_users.sql
psql $DB_URL -v password_to_save=$RIDESHARE_DB_PASSWORD -a -f db/create_role_app_user.sql
psql $DB_URL -v password_to_save=$RIDESHARE_DB_PASSWORD -a -f db/create_role_app_readonly.sql

# Set up Rideshare development database
psql $DB_URL -a -f db/create_database.sql

# Revoke database privileges on public, drop public schema
psql $DB_URL -a -f db/revoke_drop_public_schema.sql

# Create rideshare schema
psql $DB_URL -a -f db/create_schema.sql

# Perform GRANT operations
psql $DB_URL -a -f db/create_grants_database.sql
psql $DB_URL -a -f db/create_grants_schema.sql

# Alter the default privileges
psql $DB_URL -a -f db/alter_default_privileges_readwrite.sql
psql $DB_URL -a -f db/alter_default_privileges_readonly.sql
psql $DB_URL -a -f db/alter_default_privileges_public.sql

# Add generated password to ~/.pgpass file
echo "Add to ~/.pgpass"
echo "localhost:5432:rideshare_development:owner:$RIDESHARE_DB_PASSWORD
localhost:6432:rideshare_development:owner:$RIDESHARE_DB_PASSWORD
localhost:5432:rideshare_development:app:$RIDESHARE_DB_PASSWORD
localhost:54321:rideshare_development:owner:$RIDESHARE_DB_PASSWORD
localhost:54322:rideshare_development:owner:$RIDESHARE_DB_PASSWORD
*:*:*:replication_user:$RIDESHARE_DB_PASSWORD
*:*:*:app_readonly:$RIDESHARE_DB_PASSWORD" >> ~/.pgpass

# Set file ownership and permissions
echo "chmod ~/.pgpass"
chmod 0600 ~/.pgpass

echo
echo "DONE! 🎉"
echo "Notes:"
echo "Make sure 'graphviz' is installed: 'brew install graphviz'"
echo
echo "Next: run 'bin/rails db:migrate' to apply pending migrations"
echo
echo "If you ran as: 'sh db/setup.sh 2>&1 | tee -a output.log'"
echo "Open the 'output.log' file and check for errors"
echo
echo "The ~/.pgpass file was generated or new values were added to it."
echo

echo "Set the 'DATABASE_URL' env var, which you can find in the .env file:"
echo "To set it in your terminal, run:"
echo
echo "export $(cat .env|grep DATABASE_URL|head -n1)"
