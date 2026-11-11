namespace :test do
  desc 'Generate driving routes, then run optional simulator integration tests'
  task :simulator do
    ruby 'bin/generate_simulator_routes'
    # Explicit paths opt into the group excluded from default Rails discovery.
    sh({ 'RAILS_ENV' => 'test' }, RbConfig.ruby, 'bin/rails', 'test', 'test/optional/simulator')
  end
end
