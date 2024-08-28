#!/bin/bash

# USAGE:
# sh bulk_load.sh
#
# PURPOSE: Create 10_000_000 users table records for performance testing
# - Mix of Drivers and Riders
# Technique credit: <https://vnegrisolo.github.io/postgresql/generate-fake-data-using-sql>
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

-- To add additional batches of 10 million rows that
-- with unique values, uncomment the following lines
--FROM GENERATE_SERIES(10_000_001, 20_000_000) seq;
--FROM GENERATE_SERIES(20_000_001, 30_000_000) seq;
--FROM GENERATE_SERIES(30_000_001, 40_000_000) seq;
--FROM GENERATE_SERIES(40_000_001, 50_000_000) seq;
"

if [ -z "$DATABASE_URL" ]; then
    echo "Error: DATABASE_URL is not set, which provides connection information for this script."
    echo "To set it, run the following in your terminal:"
    echo
    echo "export DATABASE_URL='postgres://owner:@localhost:5432/rideshare_development'"
    exit 1
fi

echo "Creating batch of rideshare.users rows, raising statement_timeout to 30min"
psql $DATABASE_URL -c "SET statement_timeout = '30min'; $query";

echo "ANALYZE rideshare.users"
psql $DATABASE_URL -c "ANALYZE rideshare.users";

echo "Estimated count:"
psql $DATABASE_URL -c "SELECT reltuples::numeric FROM pg_class WHERE relname IN ('users');"
