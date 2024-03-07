# Copy Rideshare db/setup.sh to db01
# including all the supporting SQL files
docker exec -it db01 mkdir db
docker cp db db01:.

# Run "db/setup.sh" on db01, which should provision an empty
# rideshare_development database on the db01 instance
# On db01, the file is at "/setup.sh" in the root dir
# Preconditions:
# - env var DB_URL is set
# - env var RIDESHARE_DB_PASSWORD is set
#
# These should be set locally *first*
# so that they can be supplied to the container
#
docker exec --env DB_URL="$DB_URL" \
  --env RIDESHARE_DB_PASSWORD="$RIDESHARE_DB_PASSWORD" \
  db01 sh -c "/setup.sh"

# Once created, we won't migrate there, since we'll be copying
# tables using pg_dump

# Connect to db01 and confirm:
# - schema "rideshare" exists (\dn)
# - database "rideshare_development" exists
# - database is empty (has no tables)
docker exec --user postgres -it db01 \
  psql -d rideshare_development

# Dump the local rideshare_development database into a file
pg_dump -U postgres \
  -h localhost rideshare_development > rideshare_dump.sql

# Check the size
du -h rideshare_dump.sql

# Restore rideshare_development from the file
# to db01
# Warning: this might take a few moments!
PGPASSWORD=postgres psql -U postgres \
  -h localhost \
  -p 54321 \
  -d rideshare_development < rideshare_dump.sql

# Connect again and confirm the tables and row data
# have been loaded
# NOTE: connect as "owner"
#
docker exec --user postgres -it db01 \
  psql -U owner -d rideshare_development

# SELECT COUNT(*) FROM users; -- 20210
