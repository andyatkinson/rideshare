#!/bin/bash

export SOURCE_DB="postgres://localhost:5432/rideshare_development"

echo "Create the users_copy table"
psql $SOURCE_DB -f create_tables.sql

echo "Fill users_copy with scrubbed values"
psql $SOURCE_DB -f scrub_users.sql

# There are no constraints besides the PK constraint which was already copied
# echo "Add the generate add constraint statements function"
# psql $SOURCE_DB -c "\i ./generate_add_constraint_statements.sql"

echo "Add generate external constraints function"
psql $SOURCE_DB -c "\i ./generate_add_constraint_external_tables.sql"

echo "Capture external table constraints to a file"
psql $SOURCE_DB -c "SELECT generate_add_con_external()" --tuples-only -o constraints_external_add_back.sql

echo "external constraints"
cat constraints_external_add_back.sql

echo "Drop old users and rename new users"
psql $SOURCE_DB -f drop_and_swap_users.sql

echo "Add the external constraints to new users"
psql $SOURCE_DB -f constraints_external_add_back.sql
