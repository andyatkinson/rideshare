#!/bin/bash
# Run from Rideshare root
#
# Drop slots
# - my_subscription
# - rideshare_slot
PGPASSWORD=postgres docker exec -it db01 \
  psql -U postgres -c \
  "SELECT pg_drop_replication_slot('my_sub');"
PGPASSWORD=postgres docker exec -it db01 \
  psql -U postgres -c \
  "SELECT pg_drop_replication_slot('rideshare_slot');"

PGPASSWORD=postgres docker exec -it db01 \
  psql -U postgres -c \
  "REASSIGN OWNED BY replication_user TO postgres;"
PGPASSWORD=postgres docker exec -it db01 \
  psql -U postgres -c \
  "DROP OWNED BY replication_user;"

docker exec -it db01 \
  psql -U postgres \
  -c "DROP USER IF EXISTS replication_user"

echo "Stop everything if needed"
docker stop db01 >/dev/null 2>&1 || true
docker rm -f db01 >/dev/null 2>&1 || true

docker stop db02 >/dev/null 2>&1 || true
docker rm -f db02 >/dev/null 2>&1 || true

docker stop db03 >/dev/null 2>&1 || true
docker rm -f db03 >/dev/null 2>&1 || true

echo "Removing docker directories"
rm -rf postgres-docker
rm -rf pg18_db01_data
rm -rf pg18_db02_data
rm -rf pg18_db03_data

