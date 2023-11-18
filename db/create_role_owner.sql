-- https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/
CREATE ROLE owner
  LOGIN
  ENCRYPTED PASSWORD :'password_to_save' -- https://stackoverflow.com/a/72985243/126688
  CONNECTION LIMIT 10;

ALTER ROLE owner SET statement_timeout = 20000;
ALTER ROLE owner SET lock_timeout = 3000;
