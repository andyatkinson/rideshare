SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP INDEX IF EXISTS rideshare.trip_positions_trip_id_created_at_idx;
ALTER TABLE IF EXISTS ONLY rideshare.trip_positions DROP CONSTRAINT IF EXISTS trip_positions_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.ar_internal_metadata DROP CONSTRAINT IF EXISTS ar_internal_metadata_pkey;
DROP TABLE IF EXISTS rideshare.trip_positions;
DROP TABLE IF EXISTS rideshare.schema_migrations;
DROP TABLE IF EXISTS rideshare.ar_internal_metadata;
DROP SCHEMA IF EXISTS rideshare;
--
-- Name: rideshare; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA rideshare;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: trip_positions; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.trip_positions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "position" point NOT NULL,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: trip_positions trip_positions_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trip_positions
    ADD CONSTRAINT trip_positions_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_trip_id_created_at_idx; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX trip_positions_trip_id_created_at_idx ON rideshare.trip_positions USING btree (trip_id, created_at);


--
-- PostgreSQL database dump complete
--

SET search_path TO rideshare;

INSERT INTO "schema_migrations" (version) VALUES
('20261023210000');

