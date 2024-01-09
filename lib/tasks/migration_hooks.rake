# lib/tasks/migration_hooks.rb
#
# https://www.dan-manges.com/blog/modifying-rake-tasks

namespace :migration_hooks do
  task set_role: :environment do
    if Rails.env.development?
      puts "Setting role for development"
      ActiveRecord::Base.connection.execute("SET ROLE owner")
    end
  end
end

# https://dev.to/molly/rake-task-enhance-method-explained-3bo0
Rake::Task["db:migrate"].enhance(["migration_hooks:set_role"])
