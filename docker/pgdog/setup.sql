-- This exact DDL is applied independently to both shards on first startup.
CREATE SCHEMA rideshare;
ALTER ROLE postgres IN DATABASE rideshare_sharded SET search_path TO rideshare;

CREATE TABLE rideshare.trip_positions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    position point NOT NULL,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE INDEX ON rideshare.trip_positions (trip_id, created_at);
-- trips remains in the original application database, so no local FK is possible.
