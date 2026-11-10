require 'test_helper'

class TripCreatorConcurrencyTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test 'two simultaneous requests cannot claim the same idle driver' do
    requests = 2.times.map do
      TripRequest.create!(rider: riders(:jessica), start_location: locations(:bos), end_location: locations(:nyc))
    end
    driver_id = drivers(:meg).id
    ready, start = Queue.new, Queue.new
    threads = requests.map do |request|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          ready << true
          start.pop
          begin
            TripCreator.new(trip_request_id: request.id, driver_ids: [driver_id]).create_trip!.id
          rescue TripCreator::NoAvailableDriver
            :unavailable
          end
        end
      end
    end
    2.times { ready.pop }
    2.times { start << true }
    results = threads.map(&:value)

    assert_equal 1, results.count(:unavailable)
    assert_equal 1, Trip.where(trip_request_id: requests.map(&:id)).count
  ensure
    threads&.each(&:join)
    if requests
      Trip.where(trip_request_id: requests.map(&:id)).destroy_all
      requests.each(&:destroy!)
    end
  end
end
