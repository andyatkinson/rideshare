ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  #
  Geocoder.configure(lookup: :test, ip_lookup: :test)

  Geocoder::Lookup::Test.add_stub(
    "New York, NY", [
      {
        'coordinates'  => [40.7143528, -74.0059731],
        'address'      => 'New York, NY, USA',
        'state'        => 'New York',
        'state_code'   => 'NY',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )

  Geocoder::Lookup::Test.add_stub(
    "Boston, MA", [
      {
        'coordinates'  => [42.361145, -71.057083],
        'address'      => 'Boston, MA, USA',
        'state'        => 'Boston',
        'state_code'   => 'MA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
end
