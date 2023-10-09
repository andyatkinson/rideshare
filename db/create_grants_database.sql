\c rideshare_development

GRANT CONNECT ON DATABASE rideshare_development TO readwrite_users;
GRANT TEMPORARY ON DATABASE rideshare_development TO readwrite_users;

GRANT CONNECT ON DATABASE rideshare_development TO readonly_users;

GRANT CONNECT ON DATABASE rideshare_development TO app_readonly;
