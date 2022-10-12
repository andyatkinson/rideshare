-- With new drivers
WITH new_drivers AS (
    SELECT *
    FROM users
    WHERE created_at >= (NOW() - INTERVAL '30 days')
-- And top rated trips
), top_rated_trips AS (
    SELECT
        id,
        driver_id
    FROM trips
    WHERE rating IS NOT NULL
)
-- display their name and average rating
SELECT
    trips.driver_id,
    CONCAT(users.first_name, ' ', users.last_name) AS driver_name,
    ROUND(AVG(trips.rating), 2) as avg_rating
FROM trips
JOIN users ON trips.driver_id = users.id
WHERE users.type = 'Driver'
AND users.id IN (select id from new_drivers)
AND trips.id IN (select id from top_rated_trips)
GROUP by 1, 2
ORDER BY 3 DESC
LIMIT 10;
