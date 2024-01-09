#!/bin/bash
#
# Purpose:
# - Generate password, and place in .pgpass
# - Create replication_user using generated password, on db01
# - Copy .pgpass to db02
#
# The .pgpass password is used to authenticate replication_user, 
# when they run pg_basebackup
#
# Precondition: Make sure db01 and db02 are running
#
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

# Password for replication_user
export REP_USER_PASSWORD=$(openssl rand -hex 12)
echo "Create REP_USER_PASSWORD for replication_user"
echo $REP_USER_PASSWORD

# "rm replication_user.sql" for a clean starting point
# CREATE USER statement as SQL file
# Set password to DB_PASSWORD value
rm -f replication_user.sql
echo "CREATE USER replication_user WITH ENCRYPTED PASSWORD '$REP_USER_PASSWORD'
REPLICATION LOGIN;
GRANT SELECT ON ALL TABLES IN SCHEMA public
TO replication_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO replication_user;" >> replication_user.sql

rm -f .pgpass
echo "*:*:*:replication_user:$REP_USER_PASSWORD" >> .pgpass

# Copy replication_user.sql to db01
docker cp replication_user.sql db01:.

echo "Copy .pgpass, chown, chmod it for db02"
# Copy .pgpass to db02 postgres home dir
docker cp .pgpass db02:/var/lib/postgresql/.
docker exec --user root -it db02 chown postgres:root /var/lib/postgresql/.pgpass
docker exec --user root -it db02 chmod 0600 /var/lib/postgresql/.pgpass

# Create replication_user on db01
docker exec -it db01 \
  psql -U postgres \
  -f /replication_user.sql
