# run pg_dump for users table
# https://www.postgresql.org/docs/current/app-pgdump.html
#
# -s/--schema-only
# -O/--no-owner
# -x/--no-privileges/--no-acl
# -f/--file send output to a file

pg_dump --dbname rideshare_development --no-owner --no-privileges --file tmp/rideshare_database_dump.sql

echo "dump file created."
du -h tmp/rideshare_database_dump.sql

echo "compressing dump file, -f forced overwrite."
gzip -f tmp/rideshare_database_dump.sql

echo "gzipped file created."
du -h tmp/rideshare_database_dump.sql.gz
echo
