#!/bin/bash
#
# Make sure db01 is running, or exit
running_containers=$(docker ps --format "{{.Names}}")
if echo "$running_containers" | grep -q "db01"; then
  echo "db01 is running...continuing"
else
  echo "db01 is not running"
  echo "Exiting."
  exit 1
fi

if echo "$running_containers" | grep -q "db02"; then
  echo "db02 is running...continuing"
else
  echo "db02 is not running"
  echo "Exiting."
  exit 1
fi

export DB_PASSWORD=$(openssl rand -hex 12)
echo "Setting DB_PASSWORD"
echo $DB_PASSWORD

# Create a little template SQL file, and then
# populate it with DB_PASSWORD
# Then copy the file to the container
echo "CREATE USER replication_user WITH ENCRYPTED PASSWORD '$DB_PASSWORD'
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
