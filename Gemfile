source 'https://rubygems.org'

gem 'rails', '>= 7.1', '~> 7.1'#, git: 'https://github.com/rails/rails.git'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'geocoder', '~> 1.8'
gem 'fast_jsonapi', '~> 1.5'
gem 'jwt', '~> 2.7'
gem 'bcrypt', '~> 3.1' # Use ActiveModel has_secure_password
gem 'whenever', '~> 1.0', require: false # manage scheduled jobs
gem 'prosopite', '~> 1.4' # identify N+1 queries
gem 'pg_query', '~> 4.2'
gem 'pg_search', '~> 2.3'
gem 'activerecord-import', '~> 1.5'

# assets gems default Rails 7 app
gem 'sprockets-rails', '~> 3.4'
gem 'importmap-rails', '~> 1.2'

# Forks
gem 'pghero', git: 'https://github.com/andyatkinson/pghero.git'
gem 'pgslice', git: 'https://github.com/andyatkinson/pgslice.git'
gem 'fast_count', git: 'https://github.com/fatkodima/fast_count.git'

# Keep these updated
gem 'strong_migrations' # Use safe Migration patterns
gem 'fx' # manage DB functions, triggers
gem 'scenic' # manage DB views, materialized views

group :development, :test do
  gem 'faraday'
  gem 'json'
  gem 'rails_best_practices'
  gem 'faker', require: false
  gem 'pry'
  gem 'rails-erd'
  gem 'benchmark-ips'
  gem 'benchmark-memory'
  gem 'active_record_doctor'
  gem 'rails-pg-extras'
  gem 'database_consistency'
  gem 'dotenv-rails' # Manage .env
end
