# Exclusion constraint SQL validation
# Original credit: https://gist.githubusercontent.com/fphilipe/0a2a3d50a9f3834683bf/raw/0ab4470655b8248370bf070e15d3b32809cc70d1/exclude.sql

# using a gist index for an exclusion constraint with the extension
CREATE EXTENSION btree_gist;

INSERT INTO vehicles (name, created_at, updated_at) VALUES
('Party Bus', NOW(), NOW());

INSERT INTO vehicles (name, created_at, updated_at) VALUES
('Limo', NOW(), NOW());

INSERT INTO users (first_name, last_name, email, type, created_at, updated_at) VALUES
('Jane', 'Rider', 'jane.rider@example.com', 'Rider', NOW(), NOW());

INSERT INTO locations (address, latitude, longitude, created_at, updated_at) VALUES
('New York', 40.7143528, -74.0059731, NOW(), NOW());

INSERT INTO locations (address, latitude, longitude, created_at, updated_at) VALUES
('Comedy Cellar', 40.7303492, -74.0003215, NOW(), NOW());

INSERT INTO trip_requests (rider_id, start_location_id, end_location_id, created_at, updated_at) VALUES
(1, 1, 2, NOW(), NOW());

# Create 1 reservations for 1 day from Jan 1 to Jan 2, 2023
# - Reserve the party bus
# - Attach it to a trip request
INSERT INTO vehicle_reservations (trip_request_id, vehicle_id, starts_at, ends_at, created_at, updated_at) VALUES
(1, 1, '2023-01-01 00:00:00', '2023-01-02 11:59:00', NOW(), NOW());

# !!!!
# Creating an overlapping reservation for the Party bus is not possible
# The exclusion constraint here should be violated and the insert should be prevented
# !!!!!
INSERT INTO vehicle_reservations (trip_request_id, vehicle_id, starts_at, ends_at, created_at, updated_at) VALUES
(1, 1, '2023-01-02 08:00:00', '2023-01-02 09:00:00', NOW(), NOW());


# Assumptions, new DB or truncated all tables, reset all sequences
# e.g. truncate trips, trip_requests, users; -- etc.
# SELECT setval('public."users_id_seq"', 1);
