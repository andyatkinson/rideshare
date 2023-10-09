-- A login role
-- https://www.crunchydata.com/blog/creating-a-read-only-postgres-user
CREATE ROLE app_readonly
  LOGIN
  ENCRYPTED PASSWORD :'password_to_save'
  CONNECTION LIMIT 3;

GRANT USAGE ON SCHEMA rideshare TO app_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA rideshare TO app_readonly;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA rideshare TO app_readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA rideshare TO app_readonly;

-- Use pg_read_all_data instead of using Default Privileges
GRANT pg_read_all_data TO app_readonly;
