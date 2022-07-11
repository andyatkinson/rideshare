
-- source thes from a couple of places:
-- 1) run "rake test", and get them from "test.log"
-- 2) get them from pg_stat_statements
--
-- Add specific arguments

-- one "Transaction" counts as one run of this file
-- but file can contain multiple SQL statements, terminated
-- by a semicolon
-- https://access.crunchydata.com/documentation/postgresql11/11.5/pgbench.html


SELECT
CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
AVG(t.rating) AS avg_rating,
COUNT(t.rating) AS trip_count
FROM trips t
JOIN users d ON t.driver_id = d.id
GROUP BY t.driver_id, d.first_name, d.last_name
ORDER BY COUNT(t.rating) DESC;

-- update query

-- delete query
