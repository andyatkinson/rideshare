# Preconditions:
# - Make sure db03 has started: sh run_db_db03_replica.sh
# - wal_level = logical on db01
# - You may want to stop db02: docker stop db02

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

# Copy .rep_user_password from to db03
docker cp .rep_user_password db03:/var/lib/postgresql/.

# Connect as "postgres"
docker exec --user postgres -it db03 /bin/bash

# Set PGPASSWORD
# NOTE, PGPASSWORD does not seem to work for Subscription conn string
# Issue #144: https://github.com/andyatkinson/rideshare/issues/144
export PGPASSWORD=$(cat ~/.rep_user_password)
echo $PGPASSWORD

# Run on db01 if needed
# Corresponding replication slot for my_subscription
# (Drop slot if needed)
# SELECT PG_DROP_REPLICATION_SLOT('my_subscription');

# Generate snippet and send to psql
echo "CREATE SUBSCRIPTION my_subscription
CONNECTION 'dbname=postgres host=db01 user=replication_user password="$PGPASSWORD"'
PUBLICATION my_publication;" | psql

# View subscriptions
psql -c "SELECT * FROM pg_subscription;"
