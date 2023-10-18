namespace :benchmarks do
  desc "Code benchmarks"

  task active_record: :environment do
    Benchmark.memory do |x|
      x.report(".select_all() single User") do
        ActiveRecord::Base.connection.select_all("SELECT * FROM users ORDER BY id LIMIT 1")
      end

      x.report("User.first") { User.first }

      x.compare!
    end
  end
end
