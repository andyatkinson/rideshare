# Run with Rails Runner
rider = Rider.last
10_000.times do
  Rider.increment_counter(:trip_requests_count, rider.id)
end

# Although there are 10,000 increments for the same
# Rider, we don't have 10K records in slotted_counters
# due to the "slot" distributing the inserts
#
# This controls the growth of slotter_counters
# compared with a insert-per-increment approach

puts "getting Rider trip_requests_count"
puts rider.trip_requests_count
