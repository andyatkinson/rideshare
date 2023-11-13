-- A login role
-- https://www.crunchydata.com/blog/creating-a-read-only-postgres-user
CREATE ROLE app_readonly
  LOGIN
  ENCRYPTED PASSWORD :'password_to_save'
  CONNECTION LIMIT 3;
