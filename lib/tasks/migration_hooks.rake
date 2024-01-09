# lib/tasks/migration_hooks.rb
#
# https://www.dan-manges.com/blog/modifying-rake-tasks

namespace :migration_hooks do
  task set_role: :environment do
    puts "Setting Role to environment=#{Rails.env} for Migrations"
    if Rails.env.development?
      ActiveRecord::Base.connection.execute("SET ROLE owner")
    else
      # See: db/setup_test_database.sh
      # - APP_TEST_USER
      ActiveRecord::Base.connection.execute("SET ROLE rideshare_test")
    end
  end
end

# https://dev.to/molly/rake-task-enhance-method-explained-3bo0
Rake::Task["db:migrate"].enhance(["migration_hooks:set_role"])
