ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # PgDog has one configured test database, not Rails' per-worker database names.
  # Simulator concurrency is still exercised by its own worker-thread tests.
  parallelize(workers: 1)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  #
  Geocoder.configure(lookup: :test, ip_lookup: :test)

  Geocoder::Lookup::Test.add_stub(
    'New York, NY', [
      {
        'coordinates' => [40.7143528, -74.0059731],
        'address' => 'New York, NY, USA',
        'state' => 'New York',
        'state_code' => 'NY',
        'country' => 'United States',
        'country_code' => 'US'
      }
    ]
  )

  Geocoder::Lookup::Test.add_stub(
    'Boston, MA', [
      {
        'coordinates' => [42.361145, -71.057083],
        'address' => 'Boston, MA, USA',
        'state' => 'Boston',
        'state_code' => 'MA',
        'country' => 'United States',
        'country_code' => 'US'
      }
    ]
  )
end
