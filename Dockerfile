# PgDog runs as its own service, with its own pinned runtime image.
ARG PGDOG_IMAGE=ghcr.io/pgdogdev/pgdog:v0.1.62
FROM ${PGDOG_IMAGE} AS pgdog
COPY docker/pgdog/pgdog.toml docker/pgdog/users.toml /pgdog/

FROM ruby:3.2.2-bookworm AS base

# Install system deps, "git" needed for git gems
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      npm \
      curl \
      git && \
      echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
      curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
      apt-get update -qq && \
      apt-get install -y --no-install-recommends postgresql-client-18 && \
      rm -rf /var/lib/apt/lists/*

WORKDIR /app

# For GitHub gems
# RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

ENV BUNDLE_PATH=/usr/local/bundle

# ---- Bundler layer (cache-friendly) ----
COPY Gemfile Gemfile.lock ./
RUN bundle config set without 'development test' && \
    bundle install --jobs=4 --retry=3

# Optional Rails client for the standalone sharding demonstration.
FROM base AS pgdog-demo
RUN bundle config unset --local without && bundle install --jobs=4 --retry=3
COPY . .

# Preserve the normal application as the default build target.
FROM base AS app
COPY . .
