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

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: vehicle_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vehicle_status AS ENUM (
    'draft',
    'published'
);


--
-- Name: scrub_email(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.scrub_email(email_address character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN
  -- take random MD5 text that is the same
  -- length as the first part of the email address
  -- EXCEPT when it's less than 5 chars, since we might
  -- have a collision. In that case use 5: greatest(length,6)
  CONCAT(
    substr(
      md5(random()::text),
      0,
      greatest(length(split_part(email_address, '@', 1)) + 1, 6)
    ),
    '@',
    split_part(email_address, '@', 2)
  );
END;
$$;


--
-- Name: scrub_text(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.scrub_text(text character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN
  -- replace from position 0, to max(length or 6)
  substr(
    md5(random()::text),
    0,
    greatest(length(text) + 1, 6)
  );
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deliveries (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    trip_id bigint NOT NULL
);


--
-- Name: trips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trips (
    id bigint NOT NULL,
    trip_request_id bigint NOT NULL,
    driver_id integer NOT NULL,
    completed_at timestamp without time zone,
    rating integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT rating_check CHECK (((rating IS NULL) OR ((rating >= 1) AND (rating <= 5))))
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
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
)
WITH (autovacuum_enabled='false');


--
-- Name: fast_search_results; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.fast_search_results AS
 SELECT concat(d.first_name, ' ', d.last_name) AS driver_name,
    avg(t.rating) AS avg_rating,
    count(t.rating) AS trip_count
   FROM (public.trips t
     JOIN public.users d ON ((t.driver_id = d.id)))
  GROUP BY t.driver_id, d.first_name, d.last_name
  ORDER BY (count(t.rating)) DESC
  WITH NO DATA;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items (
    n integer,
    s text
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    address character varying NOT NULL,
    latitude numeric(15,10) NOT NULL,
    longitude numeric(15,10) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: riders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.riders (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: riders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.riders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: riders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.riders_id_seq OWNED BY public.riders.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: search_results; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.search_results AS
 SELECT concat(d.first_name, ' ', d.last_name) AS driver_name,
    avg(t.rating) AS avg_rating,
    count(t.rating) AS trip_count
   FROM (public.trips t
     JOIN public.users d ON ((t.driver_id = d.id)))
  GROUP BY t.driver_id, d.first_name, d.last_name
  ORDER BY (count(t.rating)) DESC;


--
-- Name: trip_positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions (
    id bigint NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
)
PARTITION BY RANGE (created_at);


--
-- Name: TABLE trip_positions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.trip_positions IS 'column:created_at,period:month,cast:date,version:3';


--
-- Name: trip_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trip_positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trip_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trip_positions_id_seq OWNED BY public.trip_positions.id;


--
-- Name: trip_positions_202209; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202209 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT trip_positions_202209_created_at_check CHECK (((created_at IS NOT NULL) AND (created_at >= '2022-09-01 00:00:00'::timestamp(6) without time zone) AND (created_at < '2022-10-01 00:00:00'::timestamp(6) without time zone)))
);


--
-- Name: trip_positions_202210; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202210 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.trip_positions ATTACH PARTITION public.trip_positions_202210 FOR VALUES FROM ('2022-10-01 00:00:00') TO ('2022-11-01 00:00:00');


--
-- Name: trip_positions_202211; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202211 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.trip_positions ATTACH PARTITION public.trip_positions_202211 FOR VALUES FROM ('2022-11-01 00:00:00') TO ('2022-12-01 00:00:00');


--
-- Name: trip_positions_202212; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202212 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.trip_positions ATTACH PARTITION public.trip_positions_202212 FOR VALUES FROM ('2022-12-01 00:00:00') TO ('2023-01-01 00:00:00');


--
-- Name: trip_positions_202301; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202301 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.trip_positions ATTACH PARTITION public.trip_positions_202301 FOR VALUES FROM ('2023-01-01 00:00:00') TO ('2023-02-01 00:00:00');


--
-- Name: trip_positions_202302; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202302 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.trip_positions ATTACH PARTITION public.trip_positions_202302 FOR VALUES FROM ('2023-02-01 00:00:00') TO ('2023-03-01 00:00:00');


--
-- Name: trip_positions_202303; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202303 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.trip_positions ATTACH PARTITION public.trip_positions_202303 FOR VALUES FROM ('2023-03-01 00:00:00') TO ('2023-04-01 00:00:00');


--
-- Name: trip_positions_202304; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202304 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.trip_positions ATTACH PARTITION public.trip_positions_202304 FOR VALUES FROM ('2023-04-01 00:00:00') TO ('2023-05-01 00:00:00');


--
-- Name: trip_positions_202305; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202305 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.trip_positions ATTACH PARTITION public.trip_positions_202305 FOR VALUES FROM ('2023-05-01 00:00:00') TO ('2023-06-01 00:00:00');


--
-- Name: trip_positions_202306; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_202306 (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.trip_positions ATTACH PARTITION public.trip_positions_202306 FOR VALUES FROM ('2023-06-01 00:00:00') TO ('2023-07-01 00:00:00');


--
-- Name: trip_positions_retired; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_positions_retired (
    id bigint DEFAULT nextval('public.trip_positions_id_seq'::regclass) NOT NULL,
    "position" point,
    trip_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: trip_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trip_requests (
    id bigint NOT NULL,
    rider_id integer NOT NULL,
    start_location_id integer NOT NULL,
    end_location_id integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: trip_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trip_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trip_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trip_requests_id_seq OWNED BY public.trip_requests.id;


--
-- Name: trips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trips_id_seq OWNED BY public.trips.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vehicle_reservations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vehicle_reservations (
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
-- Name: vehicle_reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vehicle_reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicle_reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vehicle_reservations_id_seq OWNED BY public.vehicle_reservations.id;


--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vehicles (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status public.vehicle_status DEFAULT 'draft'::public.vehicle_status NOT NULL
);


--
-- Name: vehicles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vehicles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vehicles_id_seq OWNED BY public.vehicles.id;


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: riders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riders ALTER COLUMN id SET DEFAULT nextval('public.riders_id_seq'::regclass);


--
-- Name: trip_positions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions ALTER COLUMN id SET DEFAULT nextval('public.trip_positions_id_seq'::regclass);


--
-- Name: trip_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_requests ALTER COLUMN id SET DEFAULT nextval('public.trip_requests_id_seq'::regclass);


--
-- Name: trips id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trips ALTER COLUMN id SET DEFAULT nextval('public.trips_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vehicle_reservations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_reservations ALTER COLUMN id SET DEFAULT nextval('public.vehicle_reservations_id_seq'::regclass);


--
-- Name: vehicles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicles ALTER COLUMN id SET DEFAULT nextval('public.vehicles_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: vehicle_reservations non_overlapping_vehicle_registration; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_reservations
    ADD CONSTRAINT non_overlapping_vehicle_registration EXCLUDE USING gist (vehicle_id WITH =, tstzrange(starts_at, ends_at) WITH &&) WHERE ((NOT canceled));


--
-- Name: riders riders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riders
    ADD CONSTRAINT riders_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: trip_positions_202209 trip_positions_202209_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202209
    ADD CONSTRAINT trip_positions_202209_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_202210 trip_positions_202210_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202210
    ADD CONSTRAINT trip_positions_202210_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_202211 trip_positions_202211_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202211
    ADD CONSTRAINT trip_positions_202211_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_202212 trip_positions_202212_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202212
    ADD CONSTRAINT trip_positions_202212_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_202301 trip_positions_202301_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202301
    ADD CONSTRAINT trip_positions_202301_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_202302 trip_positions_202302_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202302
    ADD CONSTRAINT trip_positions_202302_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_202303 trip_positions_202303_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202303
    ADD CONSTRAINT trip_positions_202303_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_202304 trip_positions_202304_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202304
    ADD CONSTRAINT trip_positions_202304_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_202305 trip_positions_202305_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202305
    ADD CONSTRAINT trip_positions_202305_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_202306 trip_positions_202306_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_202306
    ADD CONSTRAINT trip_positions_202306_pkey PRIMARY KEY (id);


--
-- Name: trip_positions_retired trip_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_positions_retired
    ADD CONSTRAINT trip_positions_pkey PRIMARY KEY (id);


--
-- Name: trip_requests trip_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_requests
    ADD CONSTRAINT trip_requests_pkey PRIMARY KEY (id);


--
-- Name: trips trips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);


--
-- Name: users users_copy_pkey1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_copy_pkey1 PRIMARY KEY (id);


--
-- Name: vehicle_reservations vehicle_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_reservations
    ADD CONSTRAINT vehicle_reservations_pkey PRIMARY KEY (id);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: index_locations_on_address; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_locations_on_address ON public.locations USING btree (address);


--
-- Name: index_locations_on_latitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_latitude ON public.locations USING btree (latitude);


--
-- Name: index_locations_on_longitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_longitude ON public.locations USING btree (longitude);


--
-- Name: index_riders_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_riders_on_name ON public.riders USING btree (name);


--
-- Name: index_trip_requests_on_end_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trip_requests_on_end_location_id ON public.trip_requests USING btree (end_location_id);


--
-- Name: index_trip_requests_on_rider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trip_requests_on_rider_id ON public.trip_requests USING btree (rider_id);


--
-- Name: index_trip_requests_on_start_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trip_requests_on_start_location_id ON public.trip_requests USING btree (start_location_id);


--
-- Name: index_trips_on_driver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trips_on_driver_id ON public.trips USING btree (driver_id);


--
-- Name: index_trips_on_rating; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trips_on_rating ON public.trips USING btree (rating);


--
-- Name: index_trips_on_trip_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trips_on_trip_request_id ON public.trips USING btree (trip_request_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_vehicle_reservations_on_vehicle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicle_reservations_on_vehicle_id ON public.vehicle_reservations USING btree (vehicle_id);


--
-- Name: index_vehicles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vehicles_on_name ON public.vehicles USING btree (name);


--
-- Name: index_vs_on_vehicle_id_partial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vs_on_vehicle_id_partial ON public.vehicle_reservations USING btree (vehicle_id) WHERE (canceled = true);


--
-- Name: items_n_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX items_n_idx ON public.items USING btree (n);


--
-- Name: trips_completed_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trips_completed_at_index ON public.trips USING btree (completed_at DESC NULLS LAST);


--
-- Name: users_first_name_email_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_first_name_email_idx ON public.users USING btree (first_name, email);


--
-- Name: users_first_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_first_name_idx ON public.users USING btree (first_name);


--
-- Name: users_fname_lname_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_fname_lname_idx ON public.users USING btree (first_name) INCLUDE (last_name);


--
-- Name: users_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_type_idx ON public.users USING btree (type);


--
-- Name: trip_requests fk_rails_3fdebbfaca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_requests
    ADD CONSTRAINT fk_rails_3fdebbfaca FOREIGN KEY (end_location_id) REFERENCES public.locations(id);


--
-- Name: trips fk_rails_6d92acb430; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT fk_rails_6d92acb430 FOREIGN KEY (trip_request_id) REFERENCES public.trip_requests(id);


--
-- Name: trip_requests fk_rails_c17a139554; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_requests
    ADD CONSTRAINT fk_rails_c17a139554 FOREIGN KEY (rider_id) REFERENCES public.users(id);


--
-- Name: trips fk_rails_e7560abc33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT fk_rails_e7560abc33 FOREIGN KEY (driver_id) REFERENCES public.users(id);


--
-- Name: trip_requests fk_rails_fa2679b626; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trip_requests
    ADD CONSTRAINT fk_rails_fa2679b626 FOREIGN KEY (start_location_id) REFERENCES public.locations(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20230126025656'),
('20221230203627'),
('20221230200725'),
('20221228194245'),
('20221227153221'),
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
('20221108172238'),
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

