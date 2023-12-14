#!/bin/bash

export SOURCE_DB="postgres://owner:@localhost:5432/rideshare_development"
echo "STARTING scrub process..."
echo "5 rows BEFORE scrubbing:"
psql $SOURCE_DB -c "SELECT * FROM users ORDER BY id ASC LIMIT 5"

# Set a seed value
psql $SOURCE_DB -c "SELECT SETSEED(0.5);"

echo "Dump views DDL"
psql $SOURCE_DB -f scrubbing/dump_views_ddl.sql \
  --tuples-only \
  --no-align \
  -o scrubbing/temp_views_ddl.sql
echo "------------------"

echo "Dump target table foreign keys creation DDL"
psql $SOURCE_DB -f scrubbing/dump_foreign_keys_ddl_target_table.sql \
  --tuples-only \
  --no-align \
  -o scrubbing/temp_foreign_keys_ddl.sql
echo "------------------"

echo "Dump primary key sequence creation DDL"
psql $SOURCE_DB -f scrubbing/dump_sequence_creation_ddl.sql \
  --tuples-only \
  --no-align \
  -o scrubbing/temp_sequences.sql
echo "------------------"

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

# echo "Add function to generate constraints"
# psql $SOURCE_DB -c "\i scrubbing/generate_add_constraint_statements.sql"

# echo "Remove existing temp_constraints.sql"
# rm scrubbing/temp_constraints.sql

# echo "Dump table constraints for tables to file"
# psql $SOURCE_DB -c "SELECT generate_add_constraint_statements()" \
#   --tuples-only \
#   -o scrubbing/temp_constraints.sql

echo "Drop and rename users table"
psql $SOURCE_DB -f scrubbing/drop_and_swap_users.sql
echo "------------------"

# echo "Add constraints"
# psql $SOURCE_DB -f scrubbing/temp_constraints.sql

echo "Add views and materialized views for target table"
psql $SOURCE_DB -f scrubbing/temp_views_ddl.sql
echo "------------------"

echo "Add constraints that refer to target table, dropped from CASCADE"
psql $SOURCE_DB -f scrubbing/temp_foreign_keys_ddl.sql
echo "------------------"

echo "Add sequence for target table, dropped from CASCADE"
psql $SOURCE_DB -f scrubbing/temp_sequences.sql
echo "------------------"

echo "Assign sequence for target table"
psql $SOURCE_DB -f scrubbing/assign_sequence.sql
echo "------------------"

echo "Success!"
echo "View 10 rows from user:"
psql $SOURCE_DB -c "SELECT * FROM users ORDER BY id ASC LIMIT 5"
