#!/bin/bash
# inspiration: https://vnegrisolo.github.io/postgresql/generate-fake-data-using-sql

# create large amounts of fake drivers and riders
query="
INSERT INTO rideshare.users(first_name, last_name, email, type, created_at, updated_at)
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

echo "Bulk loading 10_000_000 Drivers and Riders"
echo "Raising the statement_timeout"
psql $DATABASE_URL -c "SET statement_timeout = 600000; $query";
psql $DATABASE_URL -c "ANALYZE (VERBOSE) rideshare.users";
