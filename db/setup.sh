#export DB_URL="postgres://postgres:@localhost:5432/postgres"

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
