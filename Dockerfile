# syntax=docker/dockerfile:1

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

# ---- App code ----
COPY . .
