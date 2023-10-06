#!/bin/bash

export SOURCE_DB="postgres://owner:@localhost:5432/rideshare_development"

echo "Create the users_copy table"
sleep 1
psql $SOURCE_DB -f scrubbing/create_tables.sql
echo "------------------"

echo "Fill users_copy with scrubbed values"
sleep 1
psql $SOURCE_DB -f scrubbing/scrub_users.sql
echo "------------------"

# There are no constraints besides the PK constraint which was already copied
# echo "Add the generate add constraint statements function"
# psql $SOURCE_DB -c "\i ./generate_add_constraint_statements.sql"

echo "Add function to generate constraints"
psql $SOURCE_DB -c "\i scrubbing/generate_add_constraint_statements.sql"

echo "Remove existing temp_constraints.sql"
rm scrubbing/temp_constraints.sql

echo "Dump table constraints for tables to file"
psql $SOURCE_DB -c "SELECT generate_add_constraint_statements()" \
  --tuples-only \
  -o scrubbing/temp_constraints.sql

echo "Drop and rename users table"
psql $SOURCE_DB -f scrubbing/drop_and_swap_users.sql

echo "Add constraints"
psql $SOURCE_DB -f scrubbing/temp_constraints.sql
