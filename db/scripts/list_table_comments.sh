#!/bin/bash
#
# Or run: \dt+
#
# choose tables with a table level comment
query="SELECT relname, obj_description(oid)
FROM pg_class
WHERE relkind = 'r'
AND obj_description(oid) is not null"

# this should find the "users" table which has table comments
# the value for the comment can be inspected and parsed
echo "Listing comments from: $DATABASE_URL"
echo
psql $DATABASE_URL -c "$query" --csv | head -3 | tail -1
