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

echo "Getting IP address for db03..."
ip2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db03)
echo "$ip2"

echo "Add this entry to pg_hba.conf"
echo "host    replication     replication_user $ip2/32               md5"

echo
echo "When done, reload:"
echo 'docker exec --user postgres -it db01 \
    psql -c "SELECT pg_reload_conf();"'
