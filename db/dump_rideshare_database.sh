# run pg_dump for users table
# https://www.postgresql.org/docs/current/app-pgdump.html
#
# -s/--schema-only
# -f/--file send output to a file

#export DATABASE_URL="postgres://owner:@localhost:5432/rideshare_development"

pg_dump $DATABASE_URL --file tmp/rideshare_database_dump.sql

echo "dump file created."
du -h tmp/rideshare_database_dump.sql

echo "compressing dump file, -f forced overwrite."
gzip -f tmp/rideshare_database_dump.sql

echo "gzipped file created."
du -h tmp/rideshare_database_dump.sql.gz
echo
