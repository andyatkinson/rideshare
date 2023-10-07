#
# This overrides the built-in db:reset task
#
namespace :custom do
  desc "This take does something useful!"

  task :db_reset do
    sh "db/teardown.sh"
    sh "db/setup.sh"
    sh "db/setup_test_database.sh"

    Rake::Task["db:migrate"].invoke
  end
end