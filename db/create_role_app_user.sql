-- https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/
--
CREATE ROLE app WITH
  LOGIN
  ENCRYPTED PASSWORD :'password_to_save' -- https://stackoverflow.com/a/72985243/126688
  CONNECTION LIMIT 90 -- because of postgres default of 100
  IN ROLE readwrite_users;

ALTER ROLE app SET statement_timeout = 1000;
ALTER ROLE app SET lock_timeout = 750;

-- v9.6+
ALTER ROLE app SET idle_in_transaction_session_timeout = 1000;

ALTER ROLE app SET search_path = rideshare;
