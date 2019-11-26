FROM ruby:2.5-alpine

ARG RUBY_ENV=development
ARG NODE_ENV=development
ARG BUILD_ENV=development

# Define all the envs here
ENV RACK_ENV=$RUBY_ENV \
    RAILS_ENV=$RUBY_ENV \
    NODE_ENV=$NODE_ENV \
    BUILD_ENV=$BUILD_ENV

RUN apk add --no-cache nodejs yarn build-base tzdata postgresql-dev

WORKDIR /app

ENV RAILS_ENV test
ENV NODE_ENV test

ENV BUNDLE_GEMFILE=/app/Gemfile \
    BUNDLE_JOBS=4 \
    BUNDLE_PATH="/bundle"

ENV NODE_VERSION="8"

COPY Gemfile Gemfile.lock /app/

# Skip installing gem documentation
RUN mkdir -p /usr/local/etc \
      && { \
    echo '---'; \
    echo ':update_sources: true'; \
    echo ':benchmark: false'; \
    echo ':backtrace: true'; \
    echo ':verbose: true'; \
    echo 'gem: --no-ri --no-rdoc'; \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
    } >> /usr/local/etc/gemrc

# Install Ruby gems
RUN gem install bundler && \
bundle install --jobs $BUNDLE_JOBS \
                   --path $BUNDLE_PATH \
                   --without development ;

# Install JS
COPY package.json yarn.lock /app/
RUN yarn install --network-timeout 100000

# Copy app files
COPY . /app/

CMD entrypoint.sh
