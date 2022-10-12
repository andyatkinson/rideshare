# first run ./scripts/data_loaders.sh
# which will load at least 100,000 user records
# consider working with 1 million or 10 million records

# measure the estimated bloat percentage
# for the indexes on the users table

# update a portion of the rows
# for all the "even" primary key id numbers
# update their first name to Bill
#
query="
UPDATE users
SET first_name = 
  CASE (seq % 2)
    WHEN 0 THEN 'Bill' || FLOOR(RANDOM() * 10) || FLOOR(RANDOM() * 10)
    ELSE 'Jane'
  END
FROM GENERATE_SERIES(1,100000) seq
WHERE id = seq;
"

psql --dbname rideshare_development -c "$query";
