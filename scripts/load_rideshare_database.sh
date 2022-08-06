# optionally created the DB from scratch if it does not already exist
#
# createdb rideshare_development;

echo "found dump file. Size before unzip."
du -h tmp/rideshare_database_dump.sql.gz

gzip -d tmp/rideshare_database_dump.sql.gz
echo "size after unzip".
du -h tmp/rideshare_database_dump.sql

echo "loading structure and data from .sql dump file"

psql --set ON_ERROR_STOP=on --quiet --no-psqlrc --output /dev/null rideshare_development --file tmp/rideshare_database_dump.sql

echo "running some queries as confirmations"

echo "users count: "
psql --dbname rideshare_development -c "select count(*) from users"

echo "trips count: "
psql --dbname rideshare_development -c "select count(*) from trips"

echo "trip_requests count: "
psql --dbname rideshare_development -c "select count(*) from trip_requests"

echo "ratings count: "
psql --dbname rideshare_development -c "select count(*) from ratings"

echo "vehicles count: "
psql --dbname rideshare_development -c "select count(*) from vehicles"

echo "vehicle_reservations count: "
psql --dbname rideshare_development -c "select count(*) from vehicle_reservations"

echo
