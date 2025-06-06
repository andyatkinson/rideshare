source 'https://rubygems.org'

gem 'activerecord-import', '~> 1.5'
gem 'bcrypt', '~> 3.1' # Use ActiveModel has_secure_password
gem 'fast_jsonapi', '~> 1.5'
gem 'geocoder', '~> 1.8'
gem 'jwt', '~> 2.7'
gem 'pg', '~> 1.5'
gem 'pg_query', '~> 5.1'
gem 'pg_search', '~> 2.3'
gem 'prosopite', '~> 1.4' # identify N+1 queries
gem 'puma', '~> 6.4'
gem 'rails', '>= 7.1', '~> 7.1' # , git: 'https://github.com/rails/rails.git'
gem 'whenever', '~> 1.0', require: false # manage scheduled jobs

# assets gems default Rails 7 app
gem 'importmap-rails', '~> 1.2'
gem 'sprockets-rails', '~> 3.4'

# Forks
gem 'fast_count'
gem 'pghero', git: 'https://github.com/andyatkinson/pghero.git'
gem 'pgslice', git: 'https://github.com/andyatkinson/pgslice.git'

# Keep these updated
gem 'fx' # manage DB functions, triggers
gem 'scenic' # manage DB views, materialized views
gem 'strong_migrations' # Use safe Migration patterns

gem 'rubocop'
gem 'rollups'

group :development, :test do
  gem 'active_record_doctor'
  gem 'benchmark-ips'
  gem 'benchmark-memory'
  gem 'database_consistency'
  gem 'dotenv-rails' # Manage .env
  gem 'faker', require: false
  gem 'faraday'
  gem 'json'
  gem 'pry'
  gem 'rails_best_practices'
  gem 'rails-erd'
  gem 'rails-pg-extras'
end
