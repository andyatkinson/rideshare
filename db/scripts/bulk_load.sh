#!/bin/bash
#
# - Create `10_000_000` records, mix of Drivers and Riders, in `rideshare.users` using SQL
# Inspiration: <https://vnegrisolo.github.io/postgresql/generate-fake-data-using-sql>
#
query="
INSERT INTO rideshare.users(
  first_name,
  last_name,
  email,
  type,
  created_at,
  updated_at
)
SELECT
  'fname' || seq,
  'lname' || seq,
  'user_' || seq || '@' || (
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'gmail'
      WHEN 1 THEN 'hotmail'
      WHEN 2 THEN 'yahoo'
    END
  ) || '.com' AS email,
  CASE (seq % 2)
    WHEN 0 THEN 'Driver'
    ELSE 'Rider'
  END,
  NOW(),
  NOW()
FROM GENERATE_SERIES(1, 10_000_000) seq;
"

if [ -z "$DATABASE_URL" ]; then
    echo "Error: DATABASE_URL is not set."
    echo "Run: export DATABASE_URL='postgres://owner:@localhost:5432/rideshare_development'"
    exit 1
fi

echo "Creating 10_000_000 rideshare.users rows, raising statement_timeout to 600000 (10 minutes)..."
psql $DATABASE_URL -c "SET statement_timeout = 600000; $query";

echo "ANALYZE rideshare.users"
psql $DATABASE_URL -c "ANALYZE rideshare.users";
