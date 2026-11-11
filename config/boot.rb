ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Rails applies this default exclusion only when no test paths are specified.
# Optional simulator integration tests need generated driving-route data.
ENV['DEFAULT_TEST_EXCLUDE'] ||= 'test/{system,dummy,fixtures,optional}/**/*_test.rb'
