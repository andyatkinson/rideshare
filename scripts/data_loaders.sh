
# inspiration: https://vnegrisolo.github.io/postgresql/generate-fake-data-using-sql

# create large amounts of fake drivers and riders
query="
INSERT INTO users(first_name, last_name, email, type, created_at, updated_at)
SELECT
  'fname' || seq,
  'lname' || seq,
  'user_' || seq || '@' || (
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'gmail'
      WHEN 1 THEN 'hotmail'
      WHEN 2 THEN 'yahoo'
    END
  ) || '.com' AS email,
  CASE (seq % 2)
    WHEN 0 THEN 'Driver'
    ELSE 'Rider'
  END,
  NOW(),
  NOW()
FROM GENERATE_SERIES(1, 100000) seq;
"

psql --dbname rideshare_development -c "$query";


# update query, could be a way to update
# a large number of the rows to test the 
# effects of bloat
query = "
UPDATE users
SET first_name = 
  CASE (seq % 2)
    WHEN 0 THEN 'Bill'
    ELSE 'Jane'
  END
FROM GENERATE_SERIES(1,10000) seq
WHERE id = seq;
"
