docker run \
  --name db01 \
  -v local_psql_data:/var/lib/postgresql/db01data \
  -p 54321:5432 \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=db01 \
  -e POSTGRES_DB=db01 \
  --net=host \
  -d postgres:14.5
