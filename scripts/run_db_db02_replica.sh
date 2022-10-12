docker run \
  --name db02 \
  -v local_psql_data:/var/lib/postgresql/db02data \
  -p 54322:5432 \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=db02 \
  -e POSTGRES_DB=db02 \
  --net=rideshare-net \
  -d postgres:14.5
