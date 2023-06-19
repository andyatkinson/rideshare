#!/bin/bash

# Important Note:
# Run this script from parent directory
#
# cd ..
# sh scripts/reset_and_load_data_dump.sh

echo "Make tmp dir"
mkdir -p tmp

echo "Download dump file"
curl -L \
https://github.com/andyatkinson/rideshare/raw/master/rideshare_database_dump.sql.gz \
  -o tmp/rideshare_database_dump.sql.gz

echo "Decompress file"
gzip -d tmp/rideshare_database_dump.sql.gz

echo "Decompressed file is around 100 MB"
du -h tmp/rideshare_database_dump.sql

echo "Re-create the empty database"
bin/rails db:drop:all
bin/rails db:create

echo "Load the dump file using psql. This will take a minute..."
psql --set ON_ERROR_STOP=on --quiet --no-psqlrc --output /dev/null \
  rideshare_development --file tmp/rideshare_database_dump.sql

echo
echo "done!"
