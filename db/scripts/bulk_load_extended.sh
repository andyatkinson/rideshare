#!/bin/bash
#
#

echo "LOADING millions of records for trip_requests, trips..."

########################
#
# TRIP REQUESTS
# - Fake data, optimizing more for load speed vs. realistic data
#
########################
query="
INSERT INTO rideshare.trip_requests(
  rider_id,
  start_location_id,
  end_location_id,
  created_at,
  updated_at
)
SELECT
  (SELECT id FROM users WHERE type = 'Rider' ORDER BY RANDOM() LIMIT 1),
  1,
  1,
  NOW(),
  NOW()
FROM GENERATE_SERIES(1, 1_000_000) seq;
"

if [ -z "$DATABASE_URL" ]; then
    echo "Error: DATABASE_URL is not set."
    echo "Run: export DATABASE_URL='postgres://owner:@localhost:5432/rideshare_development'"
    exit 1
fi

echo "Raising statement_timeout to 600000 (10 minutes), running query..."
psql $DATABASE_URL -c "SET statement_timeout = 600000; $query";

echo "ANALYZE table"
psql $DATABASE_URL -c "ANALYZE (VERBOSE) rideshare.trip_requests";


########################
#
# TRIPS
# - Fake data, optimizing more for load speed vs. realistic data
# - Trip records are created before they're completed, CHECK constraint enforces that
#
########################

query="
WITH last_90_days AS (
  SELECT NOW() - ((RANDOM()*90)::INTEGER || 'day')::INTERVAL AS t
)
INSERT INTO rideshare.trips(
  trip_request_id,
  driver_id,
  completed_at,
  rating,
  created_at,
  updated_at
)
SELECT
  (SELECT id FROM trip_requests ORDER BY RANDOM() LIMIT 1),
  (SELECT id FROM users WHERE type = 'Driver' ORDER BY RANDOM() LIMIT 1),
  (SELECT t FROM last_90_days),
  (SELECT (RANDOM()*5)::INTEGER),
  (SELECT (t - INTERVAL '1 day') from last_90_days),
  NOW()
FROM GENERATE_SERIES(1, 1_000_000) seq;
"

if [ -z "$DATABASE_URL" ]; then
    echo "Error: DATABASE_URL is not set."
    echo "Run: export DATABASE_URL='postgres://owner:@localhost:5432/rideshare_development'"
    exit 1
fi

psql $DATABASE_URL -c "SET statement_timeout = 600000; $query";
psql $DATABASE_URL -c "ANALYZE (VERBOSE) rideshare.trips";