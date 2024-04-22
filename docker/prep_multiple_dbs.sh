#!/bin/bash
#
# Step 1:
# Replace config/database.yml content with the "sample"
# Set up DATABASE_URL_PRIMARY
# DATABASE_URL_REPLICA
#
vim config/database.yml

# version for multiple databases
#
# Change these env vars within files (overrides), if running with db01 and db02
# These should point at db01
export DB_URL="postgres://postgres:postgres@localhost:54321/postgres"
export DATABASE_URL="postgres://owner:@localhost:54321/rideshare_development"

sh db/setup.sh 2>&1 | tee -a output.log

bin/rails db:migrate

docker exec --user postgres -it db01 psql

# psql
# \dn
# \dt

docker exec --user postgres -it db02 psql

bin/rails data_generators:drivers

# We should now have 20K rows on both db01 and db02, via replication

bin/rails db --config_name rideshare
bin/rails db --config_name rideshare_replica
