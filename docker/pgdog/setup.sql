-- Bootstrap the namespace only; Rails db/pgdog_migrate owns table DDL.
CREATE SCHEMA rideshare;
SELECT format('ALTER ROLE postgres IN DATABASE %I SET search_path TO rideshare', current_database()) \gexec
