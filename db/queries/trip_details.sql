-- for trip id 1, list the first names
-- for the driver and rider
SELECT
  trips.id AS trip_id,
  driver.first_name AS driver_fname,
  rider.first_name AS rider_fname
FROM trips
JOIN trip_requests ON trips.trip_request_id = trip_requests.id
LEFT JOIN users AS driver ON trips.driver_id = driver.id
LEFT JOIN users AS rider ON trip_requests.rider_id = rider.id
WHERE trips.id = 1;
