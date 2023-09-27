#!/bin/bash

export DB_PASSWORD=$(openssl rand -hex 12)
echo "Setting DB_PASSWORD"
echo $DB_PASSWORD

# Create a little template SQL file, and then
# populate it with DB_PASSWORD
# Then copy the file to the container
cat <<< "CREATE USER replication_user
WITH ENCRYPTED PASSWORD '$DB_PASSWORD'
REPLICATION LOGIN" > replication_user.sql

# Create a .pgpass file for user
echo "*:*:*:replication_user:$DB_PASSWORD" >> .pgpass

# Set permissions on .pgpass
chmod 0600 .pgpass

# Copy replication_user.sql to db01
docker cp replication_user.sql db01:.

# Copy .pgpass to db02 container
docker cp .pgpass db02:/root/.

# Create replication_user on db01
docker exec -it db01 \
  psql -U postgres \
  -f /replication_user.sql
