-- NOTE: superusers override RLS
-- Create less priviledged users to test with
CREATE USER bob;
CREATE USER jane;
CREATE SCHEMA my_schema;
GRANT USAGE ON SCHEMA my_schema TO bob;
GRANT USAGE ON SCHEMA my_schema TO jane;
ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO bob;
ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO jane;

SET search_path = 'my_schema';

CREATE TABLE users (
  user_id serial PRIMARY KEY,
  username text UNIQUE NOT NULL
);
INSERT INTO users (username)
VALUES ('bob'), ('jane');

CREATE TABLE user_data (data TEXT, user_id INTEGER);

CREATE OR REPLACE FUNCTION current_user_id() RETURNS int AS $$
DECLARE
    found_user_id int;
BEGIN
    SELECT user_id INTO found_user_id FROM users WHERE username = CURRENT_USER;
    RETURN found_user_id;
EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN NULL; -- or raise an exception, depending on your requirements
END;
$$ LANGUAGE plpgsql STABLE;

SET ROLE bob;
INSERT INTO user_data (data, user_id)
VALUES ('bob data', current_user_id());

SET ROLE jane;
INSERT INTO user_data (data, user_id)
VALUES ('jane data', current_user_id());

-- SET ROLE andy;
-- Must be owner of table
-- Enable for user_data
ALTER TABLE user_data ENABLE ROW LEVEL SECURITY;

-- Policy for user_data
CREATE POLICY select_policy ON user_data
FOR SELECT
  USING (user_id = current_user_id());

-- Make sure it's set to ON
SET row_security TO ON;

SELECT polname, polcmd, pg_get_expr(polqual, polrelid), pg_get_expr(polwithcheck, polrelid)
FROM pg_policy
WHERE polrelid = 'user_data'::regclass;
