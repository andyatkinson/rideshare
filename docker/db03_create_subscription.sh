# Preconditions:
# - wal_level = logical on db01
#
# Verify wal_level:
# docker exec --user postgres -it db01 psql -c "SHOW wal_level"
#
# - May need to stop db02: docker stop db02

# Duplicate this line, using the new IP address:
# host    replication     replication_user 172.18.0.3/32               md5
# host    replication     replication_user 172.18.0.4/32               md5
vim pg_hba.conf

# Copy pg_hba.conf to db01
docker cp pg_hba.conf db01:/var/lib/postgresql/data/.

# Reload the config (or restart with docker restart db01)
# Monitor logs: docker logs -f db01
docker exec --user postgres -it db01 \
  psql -c "SELECT pg_reload_conf();"

# (Drop slot if needed)
# Corresponding replication slot for my_subscription
# PGPASSWORD=postgres docker exec -it db01 \
#   psql -U postgres -c \
#   "SELECT PG_DROP_REPLICATION_SLOT('my_subscription');"

# Connect as "postgres"
docker exec --user postgres -it db03 /bin/bash

# Generate snippet and send to psql
echo "CREATE SUBSCRIPTION my_subscription
CONNECTION 'dbname=postgres host=db01 user=replication_user'
PUBLICATION my_pub_inserts_only;" | psql

# View subscriptions
psql -c "SELECT * FROM pg_subscription;"
