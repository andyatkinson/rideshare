require 'faker'

namespace :data_generators do
  desc 'Generate Drivers and Riders'
  task drivers_and_riders: :environment do |_t, _args|
    Benchmark.measure do
      10_000.times.to_a.in_groups_of(10_000).each do |group|
        [Driver, Rider].each do |klass|
          batch = group.map do |i|
            first_name = Faker::Name.first_name
            last_name = Faker::Name.last_name
            drivers_license_number = (random_mn_drivers_license_number(first_name, i) if klass.equal?(Driver))
            klass.new(
              first_name: first_name,
              last_name: last_name,
              email: "#{first_name}-#{last_name}-#{klass.name.downcase}-#{i}@email.com",
              password_digest: SecureRandom.hex,
              drivers_license_number: drivers_license_number
            )
          end.map do |d|
            d.attributes.symbolize_keys.slice(
              :first_name, :last_name,
              :email, :password, :type,
              :drivers_license_number
            )
          end

          puts "bulk insert batch size: #{batch.size}"
          klass.insert_all(batch)
        end
      end
    end
  end

  desc 'Generate Trips and Trip Requests'
  task trips_and_requests: :environment do |_t, _args|
    drivers = []
    100.times do |i|
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name

      drivers_license_number = random_mn_drivers_license_number(fname, i)
      drivers << Driver.create!(
        first_name: fname,
        last_name: lname,
        email: "#{fname}-#{lname}-#{i}@email.com",
        password: SecureRandom.hex,
        drivers_license_number: drivers_license_number
      )
    end

    riders = []
    100.times do |i|
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      riders << Rider.create!(
        first_name: fname,
        last_name: lname,
        email: "#{fname}-#{lname}-#{i}@email.com",
        password: SecureRandom.hex
      )
    end

    nyc = Location.where(
      address: 'New York, NY'
    ).first_or_create do |loc|
      loc.position = '(40.7143528,-74.0059731)'
      loc.state = 'NY'
    end

    bos = Location.where(
      address: 'Boston, MA'
    ).first_or_create do |loc|
      loc.position = '(42.361145,-71.057083)'
      loc.state = 'MA'
    end

    puts 'creating Trip Requests and Trips'
    1000.times do |i|
      request = TripRequest.create!(
        rider: riders.sample,
        start_location: nyc,
        end_location: bos
      )

      # for about 1/4 of the trips, give them a random rating
      rating = i % 4 == 0 ? rand(1..5) : nil

      request.create_trip!(
        driver: drivers.sample,
        completed_at: 1.minute.from_now,
        rating: rating
      )
    end
  end

  desc 'Generate Vehicles and Reservations'
  task vehicles_and_reservations: :environment do |_t, _args|
    riders = []
    10.times do |i|
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      riders << Rider.create!(
        first_name: fname,
        last_name: lname,
        email: "#{fname}-#{lname}-#{i}@email.com",
        password: SecureRandom.hex
      )
    end

    nyc = Location.where(
      address: 'New York, NY'
    ).first_or_create do |loc|
      loc.position = '(40.7143528,-74.0059731)'
    end

    bos = Location.where(
      address: 'Boston, MA'
    ).first_or_create do |loc|
      loc.position = '(42.361145,-71.057083)'
    end

    puts 'creating trip requests and trips'
    10.times do |_i|
      TripRequest.create!(
        rider: riders.sample,
        start_location: nyc,
        end_location: bos
      )
    end

    Vehicle.destroy_all
    ['Party Bus', 'Limo', 'Ice Cream Truck', 'Food Truck'].each do |name|
      Vehicle.create!(
        name: name,
        status: VehicleStatus::PUBLISHED
      )
    end

    # create reservation
    vehicle = Vehicle.order(Arel.sql('RANDOM()')).first
    trip_request = TripRequest.order(Arel.sql('RANDOM()')).first
    starts_at = (rand * 1000).floor.hours.from_now
    ends_at = starts_at + 1.hour
    puts "v=#{vehicle.id} tr=#{trip_request.id} from=#{starts_at} to=#{ends_at}"

    VehicleReservation.create!(
      vehicle: vehicle,
      trip_request: trip_request,
      starts_at: starts_at,
      ends_at: ends_at,
      canceled: false
    )
    VehicleReservation.create!(
      vehicle: vehicle,
      trip_request: trip_request,
      starts_at: starts_at + 1.hour,
      ends_at: ends_at + 1.hour,
      canceled: true
    )
    VehicleReservation.create!(
      vehicle: vehicle,
      trip_request: trip_request,
      starts_at: starts_at + 1.hour,
      ends_at: ends_at + 1.hour,
      canceled: false
    )
  end

  # bin/rails data_generators:generate_trip_positions
  desc 'Generate simulated historical trip positions data'
  task generate_trip_positions: :environment do |_t, _args|
    # Generate data from 1 year ago, 3 months ago, 2 months ago, 1 month ago
    # and current month
    puts 'From 1 year ago'
    5.times do |_i|
      @trip = Trip.all.sample
      TripPosition.create!(
        position: '(651096.993815166,667028.1146045981)',
        trip: @trip,
        created_at: 1.year.ago
      )
    end
    puts 'From 3 months ago'
    5.times do |_i|
      @trip = Trip.all.sample
      TripPosition.create!(
        position: '(651096.993815166,667028.1146045981)',
        trip: @trip,
        created_at: 3.months.ago
      )
    end
    puts 'From 2 months ago'
    5.times do |_i|
      @trip = Trip.all.sample
      TripPosition.create!(
        position: '(651096.993815166,667028.1146045981)',
        trip: @trip,
        created_at: 2.months.ago
      )
    end
    puts 'From 1 month ago'
    5.times do |_i|
      @trip = Trip.all.sample
      TripPosition.create!(
        position: '(651096.993815166,667028.1146045981)',
        trip: @trip,
        created_at: 1.month.ago
      )
    end
    puts 'This month'
    5.times do |_i|
      @trip = Trip.all.sample
      TripPosition.create!(
        position: '(651096.993815166,667028.1146045981)',
        trip: @trip
      )
    end
    puts "Created #{TripPosition.count} records."
  end

  desc 'Run ANALYZE on all involved tables'
  task analyze_tables: :environment do |_t, _args|
    %w[ users trips trip_requests trip_positions
        locations vehicles vehicle_reservations ].each do |table_name|
      ActiveRecord::Base.connection.execute("ANALYZE #{table_name}")
    end
  end

  desc 'Generate All Data'
  task generate_all: :environment do |_t, _args|
    Rake::Task['data_generators:drivers_and_riders'].invoke
    Rake::Task['data_generators:trips_and_requests'].invoke
    Rake::Task['data_generators:vehicles_and_reservations'].invoke
    Rake::Task['data_generators:generate_trip_positions'].invoke
    Rake::Task['data_generators:analyze_tables'].invoke
  end
end

def random_mn_drivers_license_number(fname, i)
  [
    "#{fname.first.upcase}",
    '800000',
    (rand * 10).to_i.to_s,
    (rand * 10).to_i.to_s,
    (rand * 10).to_i.to_s,
    (rand * 10).to_i.to_s,
    (rand * 10).to_i.to_s,
    "#{i}"
  ].join
end
