require 'faker'

namespace :data_generators do
  desc "Generator Drivers"
  task drivers: :environment do |t, args|
    TOTAL = 20_000
    BATCH_SIZE = 10_000
    results = Benchmark.measure do
      TOTAL.times.to_a.in_groups_of(BATCH_SIZE).each do |group|
        batch = group.map do |i|
          first_name = Faker::Name.first_name
          last_name = Faker::Name.last_name
          Driver.new(
            first_name: first_name,
            last_name: last_name,
            email: "#{first_name}-#{last_name}-#{i}@email.com",
            password_digest: SecureRandom.hex
          )
        end.map do |d|
          d.attributes.symbolize_keys.slice(
            :first_name, :last_name,
            :email, :password, :type
          )
        end

        Driver.insert_all(batch)
        puts "Created #{batch.size} drivers."
      end
    end
    puts "VACUUM (ANALYZE) users"
    Driver.connection.execute("VACUUM (ANALYZE) users")
    puts results
  end
end
