namespace :data_generators do
  desc "Generator Trip data"
  task trips: :environment do |t, args|
    require 'faker'

    drivers = []
    10.times do |i|
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      drivers << Driver.create!(
        first_name: fname,
        last_name: lname,
        email: "#{fname}-#{lname}-#{i}@email.com"
      )
    end

    riders = []
    10.times do |i|
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      riders << Rider.create!(
        first_name: fname,
        last_name: lname,
        email: "#{fname}-#{lname}-#{i}@email.com"
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

    100.times do |i|
      request = TripRequest.create!(
        rider: riders.sample,
        start_location: nyc,
        end_location: bos
      )

      request.create_trip!(
        driver: drivers.sample,
        completed_at: 1.minute.ago,
        rating: 1 + rand(5)
      )
    end
  end
end
