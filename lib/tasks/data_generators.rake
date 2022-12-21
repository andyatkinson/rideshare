require 'faker'

namespace :data_generators do
  desc "Generate Drivers and Riders"
  task drivers_and_riders: :environment do |t, args|
    results = Benchmark.measure do
      10_000.times.to_a.in_groups_of(10_000).each do |group|
        [Driver, Rider].each do |klass|
          batch = group.map do |i|
            first_name = Faker::Name.first_name
            last_name = Faker::Name.last_name
            Driver.new(
              first_name: first_name,
              last_name: last_name,
              email: "#{first_name}-#{last_name}-#{klass.name.downcase}-#{i}@email.com",
              password_digest: SecureRandom.hex
            )
          end.map do |d|
            d.attributes.symbolize_keys.slice(
              :first_name, :last_name,
              :email, :password, :type
            )
          end

          puts "bulk insert batch size: #{batch.size}"
          klass.insert_all(batch)
        end
      end
    end
  end

  desc "Generate Trips and Trip Requests"
  task trips_and_requests: :environment do |t, args|
    drivers = []
    100.times do |i|
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      rand_1 = (rand * 10).to_i
      rand_2 = (rand * 10).to_i
      rand_3 = (rand * 10).to_i
      rand_4 = (rand * 10).to_i
      rand_5 = (rand * 10).to_i

      drivers_license_number = random_mn_drivers_license_number(fname, rand_1, rand_2, rand_3, rand_4, rand_5, i)
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
      address: "New York, NY",
    ).first_or_create do |loc|
      loc.latitude = 40.7143528,
      loc.longitude = -74.0059731
    end

    bos = Location.where(
      address: "Boston, MA",
    ).first_or_create do |loc|
      loc.latitude = 42.361145
      loc.longitude = -71.057083
    end

    puts "creating Trip Requests and Trips"
    1000.times do |i|
      request = TripRequest.create!(
        rider: riders.sample,
        start_location: nyc,
        end_location: bos
      )

      # for about 1/4 of the trips, give them a random rating
      rating = (i % 4 == 0) ? 1 + rand(5) : nil

      request.create_trip!(
        driver: drivers.sample,
        completed_at: 1.minute.ago,
        rating: rating
      )
    end
  end

  desc "Generate Vehicles and Reservations"
  task vehicles_and_reservations: :environment do |t, args|
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
      address: "New York, NY",
    ).first_or_create do |loc|
      loc.latitude = 40.7143528,
      loc.longitude = -74.0059731
    end

    bos = Location.where(
      address: "Boston, MA",
    ).first_or_create do |loc|
      loc.latitude = 42.361145
      loc.longitude = -71.057083
    end

    puts "creating trip requests and trips"
    100.times do |i|
      request = TripRequest.create!(
        rider: riders.sample,
        start_location: nyc,
        end_location: bos
      )
    end

    Vehicle.destroy_all
    ["Party Bus", "Limo", "Ice Cream Truck", "Food Truck"].each do |name|
      Vehicle.create!(
        name: name,
        status: VehicleStatus::PUBLISHED
      )
    end

    # create a reservation
    vehicle = Vehicle.order(Arel.sql('RANDOM()')).first
    trip_request = TripRequest.order(Arel.sql('RANDOM()')).first
    starts_at = (rand * 1000).floor.hours.from_now
    ends_at = starts_at + 1.hour
    puts "v=#{vehicle.id} tr=#{trip_request.id} from=#{starts_at} to=#{ends_at}"

    VehicleReservation.create!(
      vehicle: vehicle,
      trip_request: trip_request,
      starts_at: starts_at,
      ends_at: ends_at
    )
  end

  desc "Generate All Data"
  task generate_all: :environment do |t, args|
    Rake::Task["data_generators:drivers_and_riders"].invoke
    Rake::Task["data_generators:trips_and_requests"].invoke
    Rake::Task["data_generators:vehicles_and_reservations"].invoke
  end
end


def random_mn_drivers_license_number(fname, rand_1, rand_2, rand_3, rand_4, rand_5, i)
  [
    "#{fname.first.upcase}",
    "800000",
    rand_1.to_s,
    rand_2.to_s,
    rand_3.to_s,
    rand_4.to_s,
    rand_5.to_s,
    "#{i}"
  ].join
end
