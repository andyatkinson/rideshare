#!/bin/bash
#
# Purpose: start db03
# Copy .pgpass to it
#
# Precondition: .pgpass file exists/made earlier
#
sh run_db_db03_replica.sh

echo "Copy .pgpass, chown, chmod it for db03"
# Copy .pgpass to db03 postgres home dir
docker cp .pgpass db03:/var/lib/postgresql/.
docker exec --user root -it db03 chown postgres:root /var/lib/postgresql/.pgpass
docker exec --user root -it db03 chmod 0600 /var/lib/postgresql/.pgpass
