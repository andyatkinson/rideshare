\c rideshare_development

SET ROLE owner;
CREATE SCHEMA rideshare;
RESET ROLE;

-- set up owner earlier:
-- https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/
ALTER ROLE owner SET search_path TO rideshare;

SET search_path TO rideshare;
