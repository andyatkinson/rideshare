#!/bin/bash
#
# Purpose: Create replication slot on primary db01

PGPASSWORD=postgres docker exec -it db01 \
  psql -U postgres -c \
"CREATE PUBLICATION my_pub_inserts_only FOR ALL TABLES
WITH (PUBLISH = 'INSERT');"
