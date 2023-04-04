#!/bin/bash

echo "A script for the test DB"
bin/rails db:test:prepare
echo "Reminder: Set PGSLICE_URL to test DB in .env"
echo "Value is:"
echo $PGSLICE_URL

bin/rails runner "PgsliceHelper.new.retire_default_partition(table_name: 'trip_positions', dry_run: false)"
bin/rails runner "PgsliceHelper.new.add_partitions(table_name: 'trip_positions', past: 0, future: 3, dry_run: false)"
bin/rails runner "PgsliceHelper.new.fill(table_name: 'trip_positions', from_date: '2023-03-01')"
bin/rails runner "PgsliceHelper.new.analyze(table_name: 'trip_positions')"
bin/rails runner "PgsliceHelper.new.swap(table_name: 'trip_positions')"
