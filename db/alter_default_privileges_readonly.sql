-- Schema
-- readonly role
--
\c rideshare_development

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  IN SCHEMA rideshare
  GRANT SELECT
  ON TABLES
  TO readonly_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  IN SCHEMA rideshare
  GRANT USAGE, SELECT
  ON SEQUENCES
  TO readonly_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  IN SCHEMA rideshare
  GRANT EXECUTE
  ON FUNCTIONS
  TO readonly_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE owner
  IN SCHEMA rideshare
  GRANT USAGE
  ON TYPES
  TO readonly_users;
