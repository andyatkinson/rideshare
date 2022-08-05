# run pg_dump for users table
# https://www.postgresql.org/docs/current/app-pgdump.html
#
# -s/--schema-only
# -O/--no-owner
# -x/--no-privileges/--no-acl
# -f/--file send output to a file

pg_dump --dbname rideshare_development --no-owner --no-privileges --file tmp/dump_file.sql
