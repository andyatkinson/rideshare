-- https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/
-- Schema default privileges
-- readwrite role
--

\c rideshare_development

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  IN SCHEMA rideshare
  GRANT SELECT, INSERT, UPDATE, DELETE
  ON TABLES
  TO readwrite_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  IN SCHEMA rideshare
  GRANT USAGE, SELECT, UPDATE
  ON SEQUENCES
  TO readwrite_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  IN SCHEMA rideshare
  GRANT EXECUTE
  ON FUNCTIONS
  TO readwrite_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  IN SCHEMA rideshare
  GRANT USAGE
  ON TYPES
  TO readwrite_users;
