#!/usr/bin/env ruby

require 'rubygems'
require 'faraday'
require 'json'

# - run simulation_bootstrap rake task
#
#
# Steps in end-to-end cycle
# 1. (API) Rider creates trip_request
# 1. (API) Rider polls for trip_request status
# 1. Best available driver pickes up trip request, updates status, trip created
# 1. (API) Rider polls for trip status
# 1. Driver completes trip


# 1. create trip request
url = 'http://localhost:3000/api/trip_requests'
request_body = {
  trip_request: {
    rider_id: 1,
    start_address: 'Boston, MA',
    end_address: 'New York, NY'
  }
}
request_headers = {
  'Accept' => 'application/json'
}
response = Faraday.post(url, request_body, request_headers)
resp = JSON.parse(response.body, symbolize_names: true)
puts resp

# 1. poll for trip request status, until trip exists
if resp && trip_request_id = resp['trip_request_id'].to_i
  url = "http://localhost:3000/api/trip_requests/#{trip_request_id}"
  request_headers = {
    'Accept' => 'application/json'
  }
  response = Faraday.get(url, nil, request_headers)
  resp = JSON.parse(response.body, symbolize_names: true)
  puts resp
  trip_id = resp['trip_id']
  puts "trip_id: #{trip_id}"
end

# 1. poll for trip status, until trip is completed
