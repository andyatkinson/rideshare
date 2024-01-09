\c rideshare_development

GRANT USAGE ON SCHEMA rideshare TO readwrite_users;
GRANT USAGE ON SCHEMA rideshare TO readonly_users;

-- Not needed, but being explicit helps with \dn+
GRANT CREATE, USAGE ON SCHEMA rideshare TO owner;


-- Grants for app_readonly
GRANT USAGE ON SCHEMA rideshare TO app_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA rideshare TO app_readonly;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA rideshare TO app_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA rideshare TO app_readonly;

-- Use pg_read_all_data instead of using Default Privileges
GRANT pg_read_all_data TO app_readonly;

-- Needed for: SHOW data_directory;
-- export PGDATA="$(psql $DATABASE_URL -c 'SHOW data_directory' --tuples-only)"
GRANT pg_read_all_settings TO owner;
GRANT pg_read_all_data TO owner;
GRANT pg_read_all_stats TO owner;
