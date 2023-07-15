require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rideshare
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.


    # https://blog.bigbinary.com/2016/08/29/rails-5-disables-autoloading-after-booting-the-app-in-production.html
    config.eager_load_paths << Rails.root.join('app/services')
    config.eager_load_paths << Rails.root.join('lib')

    # Use structure.sql
    # https://edgeguides.rubyonrails.org/configuring.html#config-active-record-schema-format
    config.active_record.schema_format = :sql

    # set a timezone. Times are generally stored as
    # timestamps without a time zone. This application
    # would need to treat times based on the user's timezone.
    config.time_zone = 'Central Time (US & Canada)'

    # Enable Query Logging
    config.active_record.query_log_tags_enabled = true

    # https://www.bigbinary.com/blog/rails-7-adds-setting-for-enumerating-columns-in-select-statements#
    config.active_record.enumerate_columns_in_select_statements = true
  end
end
