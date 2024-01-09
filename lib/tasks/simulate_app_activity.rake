#
# bin/rails simulate:app_activity
#
# Set an optional iterations (default: 1)
# bin/rails simulate:app_activity[10]
#
namespace :simulate do
  desc "Simulate App Activity"
  task :app_activity, [:iteration_count] => :environment do |t, args|
    args.with_defaults(iteration_count: 1)
    # Steps in end-to-end cycle
    # 1. (API) Rider creates trip_request
    # 1. (API) Rider polls for trip_request status
    # 1. Best available driver pickes up trip request, updates status, trip created
    # 1. (API) Rider polls for trip status
    # 1. Driver completes trip

    iterations = args[:iteration_count].to_i
    puts "Running script #{iterations} times..."
    iterations.times do
      # 1. create trip request
      url = 'http://localhost:3000/api/trip_requests'
      request_body = {
        trip_request: {
          rider_id: Rider.first.id,
          start_address: 'Boston, MA',
          end_address: 'New York, NY'
        }
      }
      request_headers = {
        'Accept' => 'application/json'
      }
      puts "[trip_request] creating trip request..."
      response = Faraday.post(url, request_body, request_headers)
      resp = JSON.parse(response.body, symbolize_names: true)
      trip_request_id = resp[:trip_request_id]
      puts "[trip_request] got trip_request_id: #{trip_request_id}"

      if trip_request_id
        # 1. poll for trip request status, until trip exists
        # Polling is not implemented, would need some async processing
        # in the app like Sidekiq or another background processor
        begin
          puts "[trip_request] checking for trip_id..."
          attempts ||= 1
          url = "http://localhost:3000/api/trip_requests/#{trip_request_id}"
          show_response = Faraday.get(url)
          show_resp = JSON.parse(show_response.body, symbolize_names: true)
          puts "[trip_request] show_resp: #{show_resp.inspect}"
          trip_id = show_resp[:trip_id]
          if trip_id
            puts "[trip] Got a trip_id: #{trip_id}"
          else
            puts "[trip] no trip_id..."
            raise
          end
        rescue
          if (attempts += 1) < 5 # go back to begin block if condition ok
            puts "retrying..."
            retry
          end
        end
      end
    end

  end
end
