-- Bootstrap namespaces only; Rails db/pgdog_migrate owns table DDL.
CREATE SCHEMA IF NOT EXISTS rideshare;
SELECT format('ALTER ROLE postgres IN DATABASE %I SET search_path TO rideshare', current_database()) \gexec

SELECT 'CREATE DATABASE rideshare_test_sharded'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'rideshare_test_sharded') \gexec
\connect rideshare_test_sharded
CREATE SCHEMA IF NOT EXISTS rideshare;
ALTER ROLE postgres IN DATABASE rideshare_test_sharded SET search_path TO rideshare;
