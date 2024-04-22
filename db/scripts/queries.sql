-- Don't remove
-- Used by ./benchmark.sh

-- one "Transaction" counts as one run of this file
-- but file can contain multiple SQL statements, terminated
-- by a semicolon


-- Drivers with average rating, trip count, presented as
-- First name and Last name
-- Consider adding: expression index
SELECT
CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
AVG(t.rating) AS avg_rating,
COUNT(t.rating) AS trip_count
FROM trips t
JOIN users d ON t.driver_id = d.id
GROUP BY t.driver_id, d.first_name, d.last_name
ORDER BY COUNT(t.rating) DESC;


-- Groups the users, consider adding an index on 'type'
SELECT
  COUNT(*),
  type
FROM users
GROUP BY type;


-- Adds average trip length to earlier query
SELECT
CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
COUNT(t.id) AS trip_count,
AVG(t.rating) AS avg_rating,
AVG(t.completed_at - t.created_at) AS avg_trip_length
FROM trips t
JOIN users d ON t.driver_id = d.id AND d.type = 'Driver'
GROUP BY t.driver_id, d.first_name, d.last_name
ORDER BY COUNT(t.rating) DESC;
