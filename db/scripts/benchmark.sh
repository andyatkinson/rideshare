# https://access.crunchydata.com/documentation/postgresql11/11.5/pgbench.html
pgbench
  --host localhost
  --port 5432
  --username postgres
  --protocol prepared
  --time 60
  --jobs 8
  --client 8
  --no-vacuum
  --file queries.sql
  --report-latencies rideshare_development
