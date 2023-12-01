#!/bin/bash
#
# Purpose: Create replication slot on primary db01
#
PGPASSWORD=postgres docker exec -it db01 \
  psql -U postgres -c \
  "SELECT PG_CREATE_PHYSICAL_REPLICATION_SLOT('rideshare_slot');"
