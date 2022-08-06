require 'faker'

namespace :data_generators do
  desc "Generator Trip data"
  task drivers: :environment do |t, args|
    results = Benchmark.measure do
      1_000_000.times.to_a.in_groups_of(10_000).each do |group|
        batch = group.map do |i|
          fname = Faker::Name.first_name
          lname = Faker::Name.last_name
          Driver.new(
            first_name: fname,
            last_name: lname,
            email: "#{fname}-#{lname}-#{i}@email.com",
            password_digest: SecureRandom.hex
          )
        end.map do |d|
          d.attributes.symbolize_keys.slice(
            :first_name, :last_name,
            :email, :password, :type
          )
        end

        puts "bulk insert batch size: #{batch.size}"
        Driver.insert_all(batch)
      end
    end
    puts "created #{Driver.count} drivers."
    puts results
  end

  task trips: :environment do |t, args|
    drivers = []
    100.times do |i|
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      drivers << Driver.create!(
        first_name: fname,
        last_name: lname,
        email: "#{fname}-#{lname}-#{i}@email.com",
        password: SecureRandom.hex
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

    nyc = Location.create!(
      address: "New York, NY",
      latitude: 40.7143528,
      longitude: -74.0059731
    )

    bos = Location.create!(
      address: "Boston, MA",
      latitude: 42.361145,
      longitude: -71.057083
    )

    puts "creating trip requests and trips"
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
end
