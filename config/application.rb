require_relative 'boot'

# https://andycroll.com/ruby/turn-off-the-bits-of-rails-you-dont-use/
# require 'rails/all'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# # require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# # require "action_mailbox/engine"
# # require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rideshare
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

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
    # NOTE: Disable in order to use Prepared Statements
    # config.active_record.query_log_tags_enabled = true

    # https://www.bigbinary.com/blog/rails-7-adds-setting-for-enumerating-columns-in-select-statements#
    config.active_record.enumerate_columns_in_select_statements = true

    # Add '--if-exists' flag to pg_dump
    # https://github.com/rails/rails/issues/38695#issuecomment-763588402
    ActiveRecord::Tasks::DatabaseTasks.structure_dump_flags = ['--clean', '--if-exists']
  end
end
