-- Generic example
-- Multi-tenant applications
---
-- https://docs.citusdata.com/en/v12.1/get_started/tutorial_multi_tenant.html

-- Add tables: companies, campaigns, ads
-- "Distribution column" is the company ID
-- This is either a PK or a FK
-- companies.id
-- campaigns.company_id
-- ads.company_id

-- Then distribute the tables:
-- SELECT create_distributed_table('companies', 'id');
-- SELECT create_distributed_table('campaigns', 'company_id');
-- SELECT create_distributed_table('ads', 'company_id');

-- Tables are "colocated"

-- Bulk load data using COPY command
-- \copy companies from 'companies.csv' with csv
-- \copy campaigns from 'campaigns.csv' with csv
-- \copy ads from 'ads.csv' with csv

--docker exec -it citus psql -U owner -d rideshare_development

-- Rideshare examples

CREATE TABLE companies (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    image_url text,
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- `rideshare.users` could be a reference table
-- `rideshare.locations` could be a reference table
-- Needed to drop FKs referring to the table I wanted to make a reference table
-- alter table trip_requests drop constraint fk_rails_3fdebbfaca;
-- alter table trip_requests drop constraint fk_rails_fa2679b626;
-- alter table trip_requests drop constraint fk_rails_c17a139554;
-- alter table trips drop constraint fk_rails_e7560abc33;
SELECT create_reference_table('users');
SELECT create_reference_table('locations');

INSERT INTO companies (name, image_url)
VALUES ('MSP Rides', 'https://media.istockphoto.com/id/151520574/photo/white-formal-gloved-uniformed-hand-opening-car-door.jpg?s=1024x1024&w=is&k=20&c=Sg--aZrhlv4LOt6sOHEFhg548_Y2wYESnSAl-8RQGGQ=');

ALTER TABLE trips ADD COLUMN IF NOT EXISTS company_id BIGINT;
ALTER TABLE trip_requests ADD COLUMN IF NOT EXISTS company_id BIGINT;

ALTER TABLE trip_requests ADD CONSTRAINT fk_trip_requests_company_id
 FOREIGN KEY (company_id) REFERENCES companies(id);

ALTER TABLE trips ADD CONSTRAINT fk_trips_company_id
 FOREIGN KEY (company_id) REFERENCES companies(id);

-- Let's associate trips with a company
UPDATE trips
SET company_id = (SELECT id FROM companies LIMIT 1);

UPDATE trip_requests
SET company_id = (SELECT id FROM companies LIMIT 1);

\q

-- Run as superuser
docker exec -it citus psql -U postgres

-- Include rideshare search path
-- Should be SET ROLE postgres
-- Connected to postgres DB
SET search_path = "$user", public, rideshare;

-- Row distribution
-- ERROR:  connection to the remote node owner@localhost:5432 failed with the following error: FATAL:  too many connections for role "owner"
-- Was 10
-- Increase connections for owner
SELECT create_distributed_table('companies', 'id');

-- alter table trip_requests drop constraint trip_requests_pkey CASCADE;
SELECT create_distributed_table('trip_requests', 'company_id');

-- drop constraint from trip_positions, for demo: fk_rails_9688ac8706
-- Although trip_positions would be great to be distributed
-- Drop single column PK
SELECT create_distributed_table('trips', 'company_id');

-- Log all statements on citus Postgres:
-- ALTER DATABASE rideshare_development SET log_statement = 'all';


-- "Reference" tables concept
-- These are distributed to all workers


-- Schema-based sharding
-- https://docs.citusdata.com/en/stable/develop/reference_ddl.html
-- Schema distribution
SELECT citus_schema_distribute('user_service');

-- DDL propagation
-- https://docs.citusdata.com/en/stable/develop/api_guc.html
-- citus.enable_ddl_propagation (boolean)
