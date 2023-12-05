# Preconditions:
# - db01: wal_level = logical
#   - docker exec --user postgres -it db01 psql -c "SHOW wal_level"
# - db03 is running
# - db01 permits access from IP address of db03:
#   - See: ./db03_create_subscription_prepare.sh
# - db01 has publication "my_pub_inserts_only"

# Connect to db03 as "postgres"
docker exec --user postgres -it db03 /bin/bash

# To remove the subscription from /bin/bash db03 if needed:
# This also removes "my_sub" replication slot on db01
# psql -U postgres -c "DROP SUBSCRIPTION my_sub"

# Generate snippet and send to psql
echo "CREATE SUBSCRIPTION my_sub
CONNECTION 'dbname=postgres host=db01 user=replication_user'
PUBLICATION my_pub_inserts_only;" | psql

# View subscriptions
psql -c "SELECT * FROM pg_subscription;"
