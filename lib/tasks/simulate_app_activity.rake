# bin/rails 'simulate:app_activity[10]'
namespace :simulate do
  desc 'Fulfill trips with a fixed driver/rider/location pool (development only)'
  task :app_activity, [:iteration_count] => :environment do |_task, args|
    abort 'The activity simulator is development-only' unless Rails.env.development?

    $stdout.sync = true
    Rails.logger.level = Logger::WARN unless ENV['SIM_SQL_LOG'] == '1'

    iterations = Integer((args[:iteration_count] || '1'), 10)
    raise ArgumentError, 'iterations must be positive' unless iterations.positive?

    TripSimulator::Runner.exclusively do
      pool = TripSimulator::Pool.new(
        driver_count: ENV.fetch('SIM_DRIVERS', 5), rider_count: ENV.fetch('SIM_RIDERS', 30)
      ).prepare!
      puts "Simulator pool: #{pool.drivers.size} drivers, #{pool.riders.size} riders, #{pool.locations.size} locations"
      TripSimulator.new(
        drivers: pool.drivers, riders: pool.riders, locations: pool.locations,
        samples: ENV.fetch('SIM_SAMPLES', 73), interval: ENV.fetch('SIM_INTERVAL', 5),
        random: Random.new(Integer(ENV.fetch('SIM_SEED', Random.new_seed))),
        on_event: ->(event, trip) { puts "[#{event}] trip=#{trip.id} rider=#{trip.rider.id} driver=#{trip.driver_id} rating=#{trip.rating.inspect}" }
      ).run(iterations: iterations)
    end
    puts "Completed #{iterations} trips; drivers returned to the idle pool."
  end
end
