ENV['RAILS_ENV'] ||= 'test'
# libpq's Kerberos credential lookup can crash after Rails forks macOS workers.
# Set this before Rails opens any test connections; explicit user settings win.
ENV['PGGSSENCMODE'] ||= 'disable' if RUBY_PLATFORM.include?('darwin')
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # A single test worker avoids native-library fork issues on macOS.
  # Simulator concurrency is exercised separately by its worker-thread test.
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
