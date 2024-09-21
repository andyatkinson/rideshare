# See here for image contents: https://github.com/devcontainers/images/blob/main/src/ruby/.devcontainer/Dockerfile

# [Choice] Ruby version (use -bookworm variants on local arm64/Apple Silicon): 3, 3.2, 3.1, 3.0, 3-bookworm, 3.2-bookworm, 3.1-bookworm, 3-bullseye, 3.2-bullseye, 3.1-bullseye, 3.0-bullseye, 3-buster, 3.2-buster 3.1-buster, 3.0-buster
ARG RUBY_VERSION=3
FROM mcr.microsoft.com/devcontainers/ruby:${RUBY_VERSION}-bookworm

# borrowed some ideas from https://github.com/evilmartians/ruby-on-whales
# LABEL maintainer="Name <mail@org.com>"

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

# Add PostgreSQL APT repository
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

COPY ../Aptfile.dev /tmp/Aptfile.dev
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive \
    && grep -Ev "^ *#" /tmp/Aptfile.dev | xargs apt-get install --no-install-recommends -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the app working directory
WORKDIR /app

# Add the Rails main Gemfile and install the gems. This means the gem install can be done
# during build instead of on start. When a fork or branch has different gems, we still have an
# advantage due to caching of the other gems.
COPY Gemfile* ./
RUN bundle config set --global without "production" \
    && bundle install \
    && chown -R vscode:vscode /app /usr/local/rvm

# Run binstubs without prefixing with `bin/` or `bundle exec`
ENV PATH /app/bin:$PATH

# Expose port 3000 to the Docker host
EXPOSE 3000

# Ensure binding is always 0.0.0.0
# Binds the server to all IP addresses of the container, so it can be accessed from outside the container.
ENV BINDING="0.0.0.0"

# Start the Rails server
CMD ["bundle", "exec", "bin/rails", "server"]
