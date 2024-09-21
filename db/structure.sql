SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY rideshare.trip_requests DROP CONSTRAINT IF EXISTS fk_rails_fa2679b626;
ALTER TABLE IF EXISTS ONLY rideshare.trips DROP CONSTRAINT IF EXISTS fk_rails_e7560abc33;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_scheduled_executions DROP CONSTRAINT IF EXISTS fk_rails_c4316f352d;
ALTER TABLE IF EXISTS ONLY rideshare.trip_requests DROP CONSTRAINT IF EXISTS fk_rails_c17a139554;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_claimed_executions DROP CONSTRAINT IF EXISTS fk_rails_9cfe4d4944;
ALTER TABLE IF EXISTS ONLY rideshare.trip_positions DROP CONSTRAINT IF EXISTS fk_rails_9688ac8706;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_ready_executions DROP CONSTRAINT IF EXISTS fk_rails_81fcbd66af;
ALTER TABLE IF EXISTS ONLY rideshare.vehicle_reservations DROP CONSTRAINT IF EXISTS fk_rails_7edc8e666a;
ALTER TABLE IF EXISTS ONLY rideshare.trips DROP CONSTRAINT IF EXISTS fk_rails_6d92acb430;
ALTER TABLE IF EXISTS ONLY rideshare.vehicle_reservations DROP CONSTRAINT IF EXISTS fk_rails_59996232fc;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_blocked_executions DROP CONSTRAINT IF EXISTS fk_rails_4cd34e2228;
ALTER TABLE IF EXISTS ONLY rideshare.trip_requests DROP CONSTRAINT IF EXISTS fk_rails_3fdebbfaca;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_failed_executions DROP CONSTRAINT IF EXISTS fk_rails_39bbc7a631;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_recurring_executions DROP CONSTRAINT IF EXISTS fk_rails_318a5533ed;
DROP INDEX IF EXISTS rideshare.index_vehicles_on_name;
DROP INDEX IF EXISTS rideshare.index_vehicle_reservations_on_vehicle_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_semaphores_on_key_and_value;
DROP INDEX IF EXISTS rideshare.index_solid_queue_semaphores_on_key;
DROP INDEX IF EXISTS rideshare.index_solid_queue_semaphores_on_expires_at;
DROP INDEX IF EXISTS rideshare.index_solid_queue_scheduled_executions_on_job_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_recurring_tasks_on_static;
DROP INDEX IF EXISTS rideshare.index_solid_queue_recurring_tasks_on_key;
DROP INDEX IF EXISTS rideshare.index_solid_queue_recurring_executions_on_task_key_and_run_at;
DROP INDEX IF EXISTS rideshare.index_solid_queue_recurring_executions_on_job_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_ready_executions_on_job_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_processes_on_supervisor_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_processes_on_name_and_supervisor_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_processes_on_last_heartbeat_at;
DROP INDEX IF EXISTS rideshare.index_solid_queue_poll_by_queue;
DROP INDEX IF EXISTS rideshare.index_solid_queue_poll_all;
DROP INDEX IF EXISTS rideshare.index_solid_queue_pauses_on_queue_name;
DROP INDEX IF EXISTS rideshare.index_solid_queue_jobs_on_finished_at;
DROP INDEX IF EXISTS rideshare.index_solid_queue_jobs_on_class_name;
DROP INDEX IF EXISTS rideshare.index_solid_queue_jobs_on_active_job_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_jobs_for_filtering;
DROP INDEX IF EXISTS rideshare.index_solid_queue_jobs_for_alerting;
DROP INDEX IF EXISTS rideshare.index_solid_queue_failed_executions_on_job_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_dispatch_all;
DROP INDEX IF EXISTS rideshare.index_solid_queue_claimed_executions_on_process_id_and_job_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_claimed_executions_on_job_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_blocked_executions_on_job_id;
DROP INDEX IF EXISTS rideshare.index_solid_queue_blocked_executions_for_release;
DROP INDEX IF EXISTS rideshare.index_solid_queue_blocked_executions_for_maintenance;
DROP INDEX IF EXISTS rideshare.index_locations_on_address;
DROP INDEX IF EXISTS rideshare.index_fast_search_results_on_driver_id;
DROP INDEX IF EXISTS rideshare.idx_users_sin_cov_partial;
DROP INDEX IF EXISTS rideshare.idx_trips_multi;
DROP INDEX IF EXISTS rideshare.idx_trips_driv_rat_completed_cov_part;
DROP INDEX IF EXISTS rideshare.idx_trip_requests_sin_partial;
ALTER TABLE IF EXISTS ONLY rideshare.vehicles DROP CONSTRAINT IF EXISTS vehicles_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.vehicle_reservations DROP CONSTRAINT IF EXISTS vehicle_reservations_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.trips DROP CONSTRAINT IF EXISTS trips_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.trip_requests DROP CONSTRAINT IF EXISTS trip_requests_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.trip_positions DROP CONSTRAINT IF EXISTS trip_positions_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_semaphores DROP CONSTRAINT IF EXISTS solid_queue_semaphores_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_scheduled_executions DROP CONSTRAINT IF EXISTS solid_queue_scheduled_executions_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_recurring_tasks DROP CONSTRAINT IF EXISTS solid_queue_recurring_tasks_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_recurring_executions DROP CONSTRAINT IF EXISTS solid_queue_recurring_executions_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_ready_executions DROP CONSTRAINT IF EXISTS solid_queue_ready_executions_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_processes DROP CONSTRAINT IF EXISTS solid_queue_processes_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_pauses DROP CONSTRAINT IF EXISTS solid_queue_pauses_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_jobs DROP CONSTRAINT IF EXISTS solid_queue_jobs_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_failed_executions DROP CONSTRAINT IF EXISTS solid_queue_failed_executions_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_claimed_executions DROP CONSTRAINT IF EXISTS solid_queue_claimed_executions_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.solid_queue_blocked_executions DROP CONSTRAINT IF EXISTS solid_queue_blocked_executions_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY rideshare.vehicle_reservations DROP CONSTRAINT IF EXISTS non_overlapping_vehicle_registration;
ALTER TABLE IF EXISTS ONLY rideshare.locations DROP CONSTRAINT IF EXISTS locations_pkey;
ALTER TABLE IF EXISTS rideshare.trips DROP CONSTRAINT IF EXISTS chk_rails_4743ddc2d2;
ALTER TABLE IF EXISTS ONLY rideshare.ar_internal_metadata DROP CONSTRAINT IF EXISTS ar_internal_metadata_pkey;
ALTER TABLE IF EXISTS rideshare.vehicles ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.vehicle_reservations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.trips ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.trip_requests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.trip_positions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_semaphores ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_scheduled_executions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_recurring_tasks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_recurring_executions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_ready_executions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_processes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_pauses ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_jobs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_failed_executions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_claimed_executions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.solid_queue_blocked_executions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS rideshare.locations ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS rideshare.vehicles_id_seq;
DROP TABLE IF EXISTS rideshare.vehicles;
DROP SEQUENCE IF EXISTS rideshare.vehicle_reservations_id_seq;
DROP TABLE IF EXISTS rideshare.vehicle_reservations;
DROP SEQUENCE IF EXISTS rideshare.users_id_seq;
DROP SEQUENCE IF EXISTS rideshare.trips_id_seq;
DROP SEQUENCE IF EXISTS rideshare.trip_requests_id_seq;
DROP TABLE IF EXISTS rideshare.trip_requests;
DROP SEQUENCE IF EXISTS rideshare.trip_positions_id_seq;
DROP TABLE IF EXISTS rideshare.trip_positions;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_semaphores_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_semaphores;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_scheduled_executions_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_scheduled_executions;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_recurring_tasks_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_recurring_tasks;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_recurring_executions_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_recurring_executions;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_ready_executions_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_ready_executions;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_processes_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_processes;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_pauses_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_pauses;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_jobs_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_jobs;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_failed_executions_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_failed_executions;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_claimed_executions_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_claimed_executions;
DROP SEQUENCE IF EXISTS rideshare.solid_queue_blocked_executions_id_seq;
DROP TABLE IF EXISTS rideshare.solid_queue_blocked_executions;
DROP VIEW IF EXISTS rideshare.search_results;
DROP TABLE IF EXISTS rideshare.schema_migrations;
DROP SEQUENCE IF EXISTS rideshare.locations_id_seq;
DROP TABLE IF EXISTS rideshare.locations;
DROP MATERIALIZED VIEW IF EXISTS rideshare.fast_search_results;
DROP TABLE IF EXISTS rideshare.users;
DROP TABLE IF EXISTS rideshare.trips;
DROP TABLE IF EXISTS rideshare.ar_internal_metadata;
DROP FUNCTION IF EXISTS rideshare.scrub_text(input character varying);
DROP FUNCTION IF EXISTS rideshare.scrub_email(email_address character varying);
DROP FUNCTION IF EXISTS rideshare.fast_count(identifier text, threshold bigint);
DROP TYPE IF EXISTS rideshare.vehicle_status;
DROP SCHEMA IF EXISTS rideshare;
--
-- Name: rideshare; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA rideshare;


--
-- Name: vehicle_status; Type: TYPE; Schema: rideshare; Owner: -
--

CREATE TYPE rideshare.vehicle_status AS ENUM (
    'draft',
    'published'
);


--
-- Name: fast_count(text, bigint); Type: FUNCTION; Schema: rideshare; Owner: -
--

CREATE FUNCTION rideshare.fast_count(identifier text, threshold bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
  count bigint;
  table_parts text[];
  schema_name text;
  table_name text;
  BEGIN
    SELECT PARSE_IDENT(identifier) INTO table_parts;

    IF ARRAY_LENGTH(table_parts, 1) = 2 THEN
      schema_name := ''''|| table_parts[1] ||'''';
      table_name := ''''|| table_parts[2] ||'''';
    ELSE
      schema_name := 'ANY (current_schemas(false))';
      table_name := ''''|| table_parts[1] ||'''';
    END IF;

    EXECUTE '
      WITH tables_counts AS (
        -- inherited and partitioned tables counts
        SELECT
          ((SUM(child.reltuples::float) / greatest(SUM(child.relpages), 1))) *
            (SUM(pg_relation_size(child.oid))::float / (current_setting(''block_size'')::float))::integer AS estimate
        FROM pg_inherits
          INNER JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
          LEFT JOIN pg_namespace n ON n.oid = parent.relnamespace
          INNER JOIN pg_class child ON pg_inherits.inhrelid = child.oid
        WHERE n.nspname = '|| schema_name ||' AND
          parent.relname = '|| table_name ||'

        UNION ALL

        -- table count
        SELECT
          (reltuples::float / greatest(relpages, 1)) *
            (pg_relation_size(c.oid)::float / (current_setting(''block_size'')::float))::integer AS estimate
        FROM pg_class c
          LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE n.nspname = '|| schema_name ||' AND
          c.relname = '|| table_name ||'
      )

      SELECT
        CASE
        WHEN SUM(estimate) < '|| threshold ||' THEN (SELECT COUNT(*) FROM '|| identifier ||')
        ELSE SUM(estimate)
        END AS count
      FROM tables_counts' INTO count;
    RETURN count;
  END
$$;


--
-- Name: scrub_email(character varying); Type: FUNCTION; Schema: rideshare; Owner: -
--

CREATE FUNCTION rideshare.scrub_email(email_address character varying) RETURNS character varying
    LANGUAGE sql
    AS $$
SELECT
CONCAT(
  SUBSTR(
    MD5(RANDOM()::text),
    0,
    GREATEST(LENGTH(SPLIT_PART(email_address, '@', 1)) + 1, 6)
  ),
  '@',
  SPLIT_PART(email_address, '@', 2)
);
$$;


--
-- Name: scrub_text(character varying); Type: FUNCTION; Schema: rideshare; Owner: -
--

CREATE FUNCTION rideshare.scrub_text(input character varying) RETURNS character varying
    LANGUAGE sql
    AS $$
SELECT
-- replace from position 0, to max(length or 6)
SUBSTR(
  MD5(RANDOM()::text),
  0,
  GREATEST(LENGTH(input) + 1, 6)
);
$$;


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
-- Name: trips; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.trips (
    id bigint NOT NULL,
    trip_request_id bigint NOT NULL,
    driver_id integer NOT NULL,
    completed_at timestamp without time zone,
    rating integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: users; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.users (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    type character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    password_digest character varying,
    trips_count integer,
    drivers_license_number character varying(100)
);


--
-- Name: TABLE users; Type: COMMENT; Schema: rideshare; Owner: -
--

COMMENT ON TABLE rideshare.users IS 'sensitive_fields|first_name:scrub_text,last_name:scrub_text,email:scrub_email';


--
-- Name: fast_search_results; Type: MATERIALIZED VIEW; Schema: rideshare; Owner: -
--

CREATE MATERIALIZED VIEW rideshare.fast_search_results AS
 SELECT t.driver_id,
    concat(d.first_name, ' ', d.last_name) AS driver_name,
    avg(t.rating) AS avg_rating,
    count(t.rating) AS trip_count
   FROM (rideshare.trips t
     JOIN rideshare.users d ON ((t.driver_id = d.id)))
  GROUP BY t.driver_id, d.first_name, d.last_name
  ORDER BY (count(t.rating)) DESC
  WITH NO DATA;


--
-- Name: locations; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.locations (
    id bigint NOT NULL,
    address character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    city character varying,
    state character(2) NOT NULL,
    "position" point NOT NULL,
    CONSTRAINT state_length_check CHECK ((length(state) = 2))
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.locations_id_seq OWNED BY rideshare.locations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: search_results; Type: VIEW; Schema: rideshare; Owner: -
--

CREATE VIEW rideshare.search_results AS
 SELECT concat(d.first_name, ' ', d.last_name) AS driver_name,
    avg(t.rating) AS avg_rating,
    count(t.rating) AS trip_count
   FROM (rideshare.trips t
     JOIN rideshare.users d ON ((t.driver_id = d.id)))
  GROUP BY t.driver_id, d.first_name, d.last_name
  ORDER BY (count(t.rating)) DESC;


--
-- Name: solid_queue_blocked_executions; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_blocked_executions (
    id bigint NOT NULL,
    job_id integer NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    concurrency_key character varying NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_blocked_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_blocked_executions_id_seq OWNED BY rideshare.solid_queue_blocked_executions.id;


--
-- Name: solid_queue_claimed_executions; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_claimed_executions (
    id bigint NOT NULL,
    job_id integer NOT NULL,
    process_id bigint,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_claimed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_claimed_executions_id_seq OWNED BY rideshare.solid_queue_claimed_executions.id;


--
-- Name: solid_queue_failed_executions; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_failed_executions (
    id bigint NOT NULL,
    job_id integer NOT NULL,
    error text,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_failed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_failed_executions_id_seq OWNED BY rideshare.solid_queue_failed_executions.id;


--
-- Name: solid_queue_jobs; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_jobs (
    id bigint NOT NULL,
    queue_name character varying NOT NULL,
    class_name character varying NOT NULL,
    arguments text,
    priority integer DEFAULT 0 NOT NULL,
    active_job_id character varying,
    scheduled_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone,
    concurrency_key character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_jobs_id_seq OWNED BY rideshare.solid_queue_jobs.id;


--
-- Name: solid_queue_pauses; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_pauses (
    id bigint NOT NULL,
    queue_name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_pauses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_pauses_id_seq OWNED BY rideshare.solid_queue_pauses.id;


--
-- Name: solid_queue_processes; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_processes (
    id bigint NOT NULL,
    kind character varying NOT NULL,
    last_heartbeat_at timestamp(6) without time zone NOT NULL,
    supervisor_id bigint,
    pid integer NOT NULL,
    hostname character varying,
    metadata text,
    created_at timestamp(6) without time zone NOT NULL,
    name character varying NOT NULL
);


--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_processes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_processes_id_seq OWNED BY rideshare.solid_queue_processes.id;


--
-- Name: solid_queue_ready_executions; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_ready_executions (
    id bigint NOT NULL,
    job_id integer NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_ready_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_ready_executions_id_seq OWNED BY rideshare.solid_queue_ready_executions.id;


--
-- Name: solid_queue_recurring_executions; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_recurring_executions (
    id bigint NOT NULL,
    job_id integer NOT NULL,
    task_key character varying NOT NULL,
    run_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_recurring_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_recurring_executions_id_seq OWNED BY rideshare.solid_queue_recurring_executions.id;


--
-- Name: solid_queue_recurring_tasks; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_recurring_tasks (
    id bigint NOT NULL,
    key character varying NOT NULL,
    schedule character varying NOT NULL,
    command character varying(2048),
    class_name character varying,
    arguments text,
    queue_name character varying,
    priority integer DEFAULT 0,
    static boolean DEFAULT true NOT NULL,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_recurring_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_recurring_tasks_id_seq OWNED BY rideshare.solid_queue_recurring_tasks.id;


--
-- Name: solid_queue_scheduled_executions; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_scheduled_executions (
    id bigint NOT NULL,
    job_id integer NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    scheduled_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_scheduled_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_scheduled_executions_id_seq OWNED BY rideshare.solid_queue_scheduled_executions.id;


--
-- Name: solid_queue_semaphores; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.solid_queue_semaphores (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value integer DEFAULT 1 NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.solid_queue_semaphores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.solid_queue_semaphores_id_seq OWNED BY rideshare.solid_queue_semaphores.id;


--
-- Name: trip_positions; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.trip_positions (
    id bigint NOT NULL,
    "position" point NOT NULL,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: trip_positions_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.trip_positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trip_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.trip_positions_id_seq OWNED BY rideshare.trip_positions.id;


--
-- Name: trip_requests; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.trip_requests (
    id bigint NOT NULL,
    rider_id integer NOT NULL,
    start_location_id integer NOT NULL,
    end_location_id integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: trip_requests_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.trip_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trip_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.trip_requests_id_seq OWNED BY rideshare.trip_requests.id;


--
-- Name: trips_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.trips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trips_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.trips_id_seq OWNED BY rideshare.trips.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.users_id_seq OWNED BY rideshare.users.id;


--
-- Name: vehicle_reservations; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.vehicle_reservations (
    id bigint NOT NULL,
    vehicle_id integer NOT NULL,
    trip_request_id integer NOT NULL,
    canceled boolean DEFAULT false NOT NULL,
    starts_at timestamp with time zone NOT NULL,
    ends_at timestamp with time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: vehicle_reservations_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.vehicle_reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicle_reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.vehicle_reservations_id_seq OWNED BY rideshare.vehicle_reservations.id;


--
-- Name: vehicles; Type: TABLE; Schema: rideshare; Owner: -
--

CREATE TABLE rideshare.vehicles (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status rideshare.vehicle_status DEFAULT 'draft'::rideshare.vehicle_status NOT NULL
);


--
-- Name: vehicles_id_seq; Type: SEQUENCE; Schema: rideshare; Owner: -
--

CREATE SEQUENCE rideshare.vehicles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: rideshare; Owner: -
--

ALTER SEQUENCE rideshare.vehicles_id_seq OWNED BY rideshare.vehicles.id;


--
-- Name: locations id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.locations ALTER COLUMN id SET DEFAULT nextval('rideshare.locations_id_seq'::regclass);


--
-- Name: solid_queue_blocked_executions id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_blocked_executions ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_blocked_executions_id_seq'::regclass);


--
-- Name: solid_queue_claimed_executions id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_claimed_executions ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_claimed_executions_id_seq'::regclass);


--
-- Name: solid_queue_failed_executions id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_failed_executions ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_failed_executions_id_seq'::regclass);


--
-- Name: solid_queue_jobs id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_jobs ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_jobs_id_seq'::regclass);


--
-- Name: solid_queue_pauses id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_pauses ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_pauses_id_seq'::regclass);


--
-- Name: solid_queue_processes id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_processes ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_processes_id_seq'::regclass);


--
-- Name: solid_queue_ready_executions id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_ready_executions ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_ready_executions_id_seq'::regclass);


--
-- Name: solid_queue_recurring_executions id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_recurring_executions ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_recurring_executions_id_seq'::regclass);


--
-- Name: solid_queue_recurring_tasks id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_recurring_tasks ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_recurring_tasks_id_seq'::regclass);


--
-- Name: solid_queue_scheduled_executions id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_scheduled_executions ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_scheduled_executions_id_seq'::regclass);


--
-- Name: solid_queue_semaphores id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_semaphores ALTER COLUMN id SET DEFAULT nextval('rideshare.solid_queue_semaphores_id_seq'::regclass);


--
-- Name: trip_positions id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trip_positions ALTER COLUMN id SET DEFAULT nextval('rideshare.trip_positions_id_seq'::regclass);


--
-- Name: trip_requests id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trip_requests ALTER COLUMN id SET DEFAULT nextval('rideshare.trip_requests_id_seq'::regclass);


--
-- Name: trips id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trips ALTER COLUMN id SET DEFAULT nextval('rideshare.trips_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.users ALTER COLUMN id SET DEFAULT nextval('rideshare.users_id_seq'::regclass);


--
-- Name: vehicle_reservations id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.vehicle_reservations ALTER COLUMN id SET DEFAULT nextval('rideshare.vehicle_reservations_id_seq'::regclass);


--
-- Name: vehicles id; Type: DEFAULT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.vehicles ALTER COLUMN id SET DEFAULT nextval('rideshare.vehicles_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: trips chk_rails_4743ddc2d2; Type: CHECK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE rideshare.trips
    ADD CONSTRAINT chk_rails_4743ddc2d2 CHECK ((completed_at > created_at)) NOT VALID;


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: vehicle_reservations non_overlapping_vehicle_registration; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.vehicle_reservations
    ADD CONSTRAINT non_overlapping_vehicle_registration EXCLUDE USING gist (int4range(vehicle_id, vehicle_id, '[]'::text) WITH =, tstzrange(starts_at, ends_at) WITH &&) WHERE ((NOT canceled));


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: solid_queue_blocked_executions solid_queue_blocked_executions_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_blocked_executions
    ADD CONSTRAINT solid_queue_blocked_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_claimed_executions solid_queue_claimed_executions_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_claimed_executions
    ADD CONSTRAINT solid_queue_claimed_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_failed_executions solid_queue_failed_executions_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_failed_executions
    ADD CONSTRAINT solid_queue_failed_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_jobs solid_queue_jobs_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_jobs
    ADD CONSTRAINT solid_queue_jobs_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_pauses solid_queue_pauses_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_pauses
    ADD CONSTRAINT solid_queue_pauses_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_processes solid_queue_processes_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_processes
    ADD CONSTRAINT solid_queue_processes_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_ready_executions solid_queue_ready_executions_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_ready_executions
    ADD CONSTRAINT solid_queue_ready_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_recurring_executions solid_queue_recurring_executions_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_recurring_executions
    ADD CONSTRAINT solid_queue_recurring_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_recurring_tasks solid_queue_recurring_tasks_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_recurring_tasks
    ADD CONSTRAINT solid_queue_recurring_tasks_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_scheduled_executions solid_queue_scheduled_executions_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_scheduled_executions
    ADD CONSTRAINT solid_queue_scheduled_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_semaphores solid_queue_semaphores_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_semaphores
    ADD CONSTRAINT solid_queue_semaphores_pkey PRIMARY KEY (id);


--
-- Name: trip_positions trip_positions_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trip_positions
    ADD CONSTRAINT trip_positions_pkey PRIMARY KEY (id);


--
-- Name: trip_requests trip_requests_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trip_requests
    ADD CONSTRAINT trip_requests_pkey PRIMARY KEY (id);


--
-- Name: trips trips_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vehicle_reservations vehicle_reservations_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.vehicle_reservations
    ADD CONSTRAINT vehicle_reservations_pkey PRIMARY KEY (id);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: idx_trip_requests_sin_partial; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX idx_trip_requests_sin_partial ON rideshare.trip_requests USING btree (id) WHERE (end_location_id = 2);


--
-- Name: idx_trips_driv_rat_completed_cov_part; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX idx_trips_driv_rat_completed_cov_part ON rideshare.trips USING btree (driver_id) INCLUDE (rating) WHERE ((rating IS NOT NULL) AND (completed_at IS NOT NULL));


--
-- Name: idx_trips_multi; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX idx_trips_multi ON rideshare.trips USING btree (completed_at, trip_request_id, driver_id);


--
-- Name: idx_users_sin_cov_partial; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX idx_users_sin_cov_partial ON rideshare.users USING btree (id) INCLUDE (first_name, last_name) WHERE ((type)::text = 'Driver'::text);


--
-- Name: index_fast_search_results_on_driver_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_fast_search_results_on_driver_id ON rideshare.fast_search_results USING btree (driver_id);


--
-- Name: index_locations_on_address; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_locations_on_address ON rideshare.locations USING btree (address);


--
-- Name: index_solid_queue_blocked_executions_for_maintenance; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_blocked_executions_for_maintenance ON rideshare.solid_queue_blocked_executions USING btree (expires_at, concurrency_key);


--
-- Name: index_solid_queue_blocked_executions_for_release; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_blocked_executions_for_release ON rideshare.solid_queue_blocked_executions USING btree (concurrency_key, priority, job_id);


--
-- Name: index_solid_queue_blocked_executions_on_job_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_blocked_executions_on_job_id ON rideshare.solid_queue_blocked_executions USING btree (job_id);


--
-- Name: index_solid_queue_claimed_executions_on_job_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_claimed_executions_on_job_id ON rideshare.solid_queue_claimed_executions USING btree (job_id);


--
-- Name: index_solid_queue_claimed_executions_on_process_id_and_job_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_claimed_executions_on_process_id_and_job_id ON rideshare.solid_queue_claimed_executions USING btree (process_id, job_id);


--
-- Name: index_solid_queue_dispatch_all; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_dispatch_all ON rideshare.solid_queue_scheduled_executions USING btree (scheduled_at, priority, job_id);


--
-- Name: index_solid_queue_failed_executions_on_job_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_failed_executions_on_job_id ON rideshare.solid_queue_failed_executions USING btree (job_id);


--
-- Name: index_solid_queue_jobs_for_alerting; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_jobs_for_alerting ON rideshare.solid_queue_jobs USING btree (scheduled_at, finished_at);


--
-- Name: index_solid_queue_jobs_for_filtering; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_jobs_for_filtering ON rideshare.solid_queue_jobs USING btree (queue_name, finished_at);


--
-- Name: index_solid_queue_jobs_on_active_job_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_active_job_id ON rideshare.solid_queue_jobs USING btree (active_job_id);


--
-- Name: index_solid_queue_jobs_on_class_name; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_class_name ON rideshare.solid_queue_jobs USING btree (class_name);


--
-- Name: index_solid_queue_jobs_on_finished_at; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_finished_at ON rideshare.solid_queue_jobs USING btree (finished_at);


--
-- Name: index_solid_queue_pauses_on_queue_name; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_pauses_on_queue_name ON rideshare.solid_queue_pauses USING btree (queue_name);


--
-- Name: index_solid_queue_poll_all; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_poll_all ON rideshare.solid_queue_ready_executions USING btree (priority, job_id);


--
-- Name: index_solid_queue_poll_by_queue; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_poll_by_queue ON rideshare.solid_queue_ready_executions USING btree (queue_name, priority, job_id);


--
-- Name: index_solid_queue_processes_on_last_heartbeat_at; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_processes_on_last_heartbeat_at ON rideshare.solid_queue_processes USING btree (last_heartbeat_at);


--
-- Name: index_solid_queue_processes_on_name_and_supervisor_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_processes_on_name_and_supervisor_id ON rideshare.solid_queue_processes USING btree (name, supervisor_id);


--
-- Name: index_solid_queue_processes_on_supervisor_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_processes_on_supervisor_id ON rideshare.solid_queue_processes USING btree (supervisor_id);


--
-- Name: index_solid_queue_ready_executions_on_job_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_ready_executions_on_job_id ON rideshare.solid_queue_ready_executions USING btree (job_id);


--
-- Name: index_solid_queue_recurring_executions_on_job_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_job_id ON rideshare.solid_queue_recurring_executions USING btree (job_id);


--
-- Name: index_solid_queue_recurring_executions_on_task_key_and_run_at; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_task_key_and_run_at ON rideshare.solid_queue_recurring_executions USING btree (task_key, run_at);


--
-- Name: index_solid_queue_recurring_tasks_on_key; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_recurring_tasks_on_key ON rideshare.solid_queue_recurring_tasks USING btree (key);


--
-- Name: index_solid_queue_recurring_tasks_on_static; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_recurring_tasks_on_static ON rideshare.solid_queue_recurring_tasks USING btree (static);


--
-- Name: index_solid_queue_scheduled_executions_on_job_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_scheduled_executions_on_job_id ON rideshare.solid_queue_scheduled_executions USING btree (job_id);


--
-- Name: index_solid_queue_semaphores_on_expires_at; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_semaphores_on_expires_at ON rideshare.solid_queue_semaphores USING btree (expires_at);


--
-- Name: index_solid_queue_semaphores_on_key; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_semaphores_on_key ON rideshare.solid_queue_semaphores USING btree (key);


--
-- Name: index_solid_queue_semaphores_on_key_and_value; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_solid_queue_semaphores_on_key_and_value ON rideshare.solid_queue_semaphores USING btree (key, value);


--
-- Name: index_vehicle_reservations_on_vehicle_id; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE INDEX index_vehicle_reservations_on_vehicle_id ON rideshare.vehicle_reservations USING btree (vehicle_id);


--
-- Name: index_vehicles_on_name; Type: INDEX; Schema: rideshare; Owner: -
--

CREATE UNIQUE INDEX index_vehicles_on_name ON rideshare.vehicles USING btree (name);


--
-- Name: solid_queue_recurring_executions fk_rails_318a5533ed; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_recurring_executions
    ADD CONSTRAINT fk_rails_318a5533ed FOREIGN KEY (job_id) REFERENCES rideshare.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: solid_queue_failed_executions fk_rails_39bbc7a631; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_failed_executions
    ADD CONSTRAINT fk_rails_39bbc7a631 FOREIGN KEY (job_id) REFERENCES rideshare.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: trip_requests fk_rails_3fdebbfaca; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trip_requests
    ADD CONSTRAINT fk_rails_3fdebbfaca FOREIGN KEY (end_location_id) REFERENCES rideshare.locations(id);


--
-- Name: solid_queue_blocked_executions fk_rails_4cd34e2228; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_blocked_executions
    ADD CONSTRAINT fk_rails_4cd34e2228 FOREIGN KEY (job_id) REFERENCES rideshare.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: vehicle_reservations fk_rails_59996232fc; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.vehicle_reservations
    ADD CONSTRAINT fk_rails_59996232fc FOREIGN KEY (trip_request_id) REFERENCES rideshare.trip_requests(id);


--
-- Name: trips fk_rails_6d92acb430; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trips
    ADD CONSTRAINT fk_rails_6d92acb430 FOREIGN KEY (trip_request_id) REFERENCES rideshare.trip_requests(id);


--
-- Name: vehicle_reservations fk_rails_7edc8e666a; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.vehicle_reservations
    ADD CONSTRAINT fk_rails_7edc8e666a FOREIGN KEY (vehicle_id) REFERENCES rideshare.vehicles(id);


--
-- Name: solid_queue_ready_executions fk_rails_81fcbd66af; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_ready_executions
    ADD CONSTRAINT fk_rails_81fcbd66af FOREIGN KEY (job_id) REFERENCES rideshare.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: trip_positions fk_rails_9688ac8706; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trip_positions
    ADD CONSTRAINT fk_rails_9688ac8706 FOREIGN KEY (trip_id) REFERENCES rideshare.trips(id);


--
-- Name: solid_queue_claimed_executions fk_rails_9cfe4d4944; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_claimed_executions
    ADD CONSTRAINT fk_rails_9cfe4d4944 FOREIGN KEY (job_id) REFERENCES rideshare.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: trip_requests fk_rails_c17a139554; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trip_requests
    ADD CONSTRAINT fk_rails_c17a139554 FOREIGN KEY (rider_id) REFERENCES rideshare.users(id);


--
-- Name: solid_queue_scheduled_executions fk_rails_c4316f352d; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.solid_queue_scheduled_executions
    ADD CONSTRAINT fk_rails_c4316f352d FOREIGN KEY (job_id) REFERENCES rideshare.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: trips fk_rails_e7560abc33; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trips
    ADD CONSTRAINT fk_rails_e7560abc33 FOREIGN KEY (driver_id) REFERENCES rideshare.users(id);


--
-- Name: trip_requests fk_rails_fa2679b626; Type: FK CONSTRAINT; Schema: rideshare; Owner: -
--

ALTER TABLE ONLY rideshare.trip_requests
    ADD CONSTRAINT fk_rails_fa2679b626 FOREIGN KEY (start_location_id) REFERENCES rideshare.locations(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO rideshare;

INSERT INTO "schema_migrations" (version) VALUES
('20240906033935'),
('20240905235053'),
('20231220043547'),
('20231218215836'),
('20231213045957'),
('20231208050516'),
('20231018153712'),
('20231018153441'),
('20230925150831'),
('20230925150207'),
('20230726020548'),
('20230716174139'),
('20230714013609'),
('20230713150710'),
('20230713150550'),
('20230711015123'),
('20230625151410'),
('20230620030038'),
('20230619213546'),
('20230314210022'),
('20230314204931'),
('20230126025656'),
('20230125003946'),
('20230125003531'),
('20221230203627'),
('20221230200725'),
('20221223161403'),
('20221221052616'),
('20221220201836'),
('20221219164626'),
('20221111213918'),
('20221111212740'),
('20221110020532'),
('20221108175619'),
('20221108175321'),
('20221108172933'),
('20221007184855'),
('20220916171314'),
('20220814175213'),
('20220801140121'),
('20220729020430'),
('20220729014635'),
('20220716020213'),
('20220711015524'),
('20220711015454'),
('20220711010541'),
('20200603150442'),
('20191203213103'),
('20191203212055'),
('20191121175429'),
('20191112165848'),
('20191111151637'),
('20191108221519'),
('20191107212726');

