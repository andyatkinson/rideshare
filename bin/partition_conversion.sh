echo "A script for the test DB"
bin/rails db:test:prepare
echo "Reminder: Set PGSLICE_URL to test DB in .env"

echo "retire"
bin/rails runner "PgsliceHelper.new.retire_default_partition(table_name: 'trip_positions')"

# To unretire for mistakes, or to reset, invoke next line
#bin/rails runner "PgsliceHelper.new.unretire_default_partition(table_name: 'trip_positions')"
