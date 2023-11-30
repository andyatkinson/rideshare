#!/bin/bash
#
# Purpose: Create replication_user user
# - Create on primary instance: db01
# - Copy generated password to replica: db02
#
# The password is used for authentication when running pg_basebackup
# for the replication_user user
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
GRANT SELECT ON TABLES TO replication_user;" > replication_user.sql

# "rm .rep_user_password" for a clean starting point
# Create a .rep_user_password file for replication_user
rm -f .rep_user_password
echo "$REP_USER_PASSWORD" >> .rep_user_password

# Copy replication_user.sql to db01
docker cp replication_user.sql db01:.

# Copy .rep_user_password to db02 postgres home dir
docker cp .rep_user_password db02:/var/lib/postgresql/.

# Create replication_user on db01
docker exec -it db01 \
  psql -U postgres \
  -f /replication_user.sql
