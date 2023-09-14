-- https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/
CREATE ROLE owner
  LOGIN
  ENCRYPTED PASSWORD ':RIDESHARE_DB_PASSWORD'
  CONNECTION LIMIT 3;

ALTER ROLE owner SET statement_timeout = 20000;
ALTER ROLE owner SET lock_timeout = 3000;
