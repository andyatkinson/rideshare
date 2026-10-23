#!/bin/sh
set -eu
psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER:-postgres}" -d postgres -c 'CREATE DATABASE rideshare_sharded_test'
psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER:-postgres}" -d rideshare_sharded_test -f /docker-entrypoint-initdb.d/setup.sql
