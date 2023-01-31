# db01 can be created as wal_level = logical
#
# db01 when sets wal_level = logical on the publisher side
# - creates a publication
#
# db03 will be a replica where a subscription is created

docker run \
  --name db03 \
  -v local_psql_data:/var/lib/postgresql/db03data \
  -p 54323:5432 \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=db03 \
  -e POSTGRES_DB=db03 \
  --net=rideshare-net \
  -d postgres:14.5
