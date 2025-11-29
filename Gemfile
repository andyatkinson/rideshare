source 'https://rubygems.org'

gem 'activerecord-import', '~> 1.5'
gem 'bcrypt', '~> 3.1' # Use ActiveModel has_secure_password
gem 'fast_jsonapi', '~> 1.5'
gem 'geocoder', '~> 1.8'
gem 'jwt', '~> 2.7'
gem 'pg', '~> 1.5'
gem 'pg_query', '~> 6.1'
gem 'pg_search', '~> 2.3'
gem 'prosopite', '~> 1.4' # identify N+1 queries
gem 'puma', '~> 6.4'
gem 'rails', '>= 7.1', '~> 7.1' # , git: 'https://github.com/rails/rails.git'
gem 'whenever', '~> 1.0', require: false # manage scheduled jobs
gem 'fast_count', '~> 0.3'

# assets gems default Rails 7 app
gem 'importmap-rails', '~> 1.2'
gem 'sprockets-rails', '~> 3.4'

# Forks
gem 'pghero', git: 'https://github.com/andyatkinson/pghero.git'
gem 'pgslice', git: 'https://github.com/andyatkinson/pgslice.git'

# Keep these updated
gem 'fx', '~> 0.9' # manage DB functions, triggers
gem 'scenic', '~> 1.9' # manage DB views, materialized views
gem 'strong_migrations', '~> 2.4' # Use safe Migration patterns

gem 'rubocop', '~> 1.77'

group :development, :test do
  gem 'active_record_doctor', '~> 1.15'
  gem 'benchmark-ips', '~> 2.14'
  gem 'benchmark-memory', '~> 0.2'
  gem 'database_consistency', '~> 2.0'
  gem 'dotenv-rails', '~> 3.1' # Manage .env
  gem 'faker', '~> 3.5', require: false
  gem 'faraday', '~> 2.13'
  gem 'json', '~> 2.1'
  gem 'pry', '~> 0.15'
  gem 'rails_best_practices', '~> 1.23'
  gem 'rails-erd', '~> 1.7'
  gem 'rails-pg-extras', '~> 5.6'
end
