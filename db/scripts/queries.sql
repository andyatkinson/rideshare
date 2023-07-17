
-- source thes from a couple of places:
-- 1) run "rake test", and get them from "test.log"
-- 2) get them from pg_stat_statements
--
-- Add specific arguments

-- one "Transaction" counts as one run of this file
-- but file can contain multiple SQL statements, terminated
-- by a semicolon
-- https://access.crunchydata.com/documentation/postgresql11/11.5/pgbench.html

-- Run the data loaders first

-- perhaps need an expression index
SELECT
CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
AVG(t.rating) AS avg_rating,
COUNT(t.rating) AS trip_count
FROM trips t
JOIN users d ON t.driver_id = d.id
GROUP BY t.driver_id, d.first_name, d.last_name
ORDER BY COUNT(t.rating) DESC;

-- group the users, need an index on 'type'
select count(*),type from users group by type;

-- update some rows with diverse primary key IDs

-- delete some rows with diverse ids


SELECT
CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
COUNT(t.id) AS trip_count,
AVG(t.rating) AS avg_rating,
AVG(t.completed_at - t.created_at) AS avg_duraton
FROM trips t
JOIN users d ON t.driver_id = d.id AND d.type = 'Driver'
GROUP BY t.driver_id, d.first_name, d.last_name
ORDER BY COUNT(t.rating) DESC;
