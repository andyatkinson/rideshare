\c rideshare_development

GRANT USAGE ON SCHEMA rideshare TO readwrite_users;
GRANT USAGE ON SCHEMA rideshare TO readonly_users;

-- Not needed, but being explicit helps with \dn+
GRANT CREATE, USAGE ON SCHEMA rideshare TO owner;
