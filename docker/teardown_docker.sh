#!/bin/bash
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
docker stop db01 && docker rm db01
docker stop db02 && docker rm db02
docker stop db03 && docker rm db03

echo "Removing local postgres-docker directory"
rm -rf postgres-docker
