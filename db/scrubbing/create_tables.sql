-- Among tables:
-- users, locations, trip_requests, trips, vehicles, vehicle_reservations
-- Only sensitive fields in tables: users
DROP TABLE IF EXISTS users_copy CASCADE;

CREATE TABLE users_copy (LIKE users INCLUDING ALL);
