module PgdogDemo
  class Record < ActiveRecord::Base
    self.abstract_class = true

    # Separate connection: the normal application's models keep their database.
    establish_connection(
      adapter: 'postgresql',
      url: ENV.fetch('PGDOG_DATABASE_URL', 'postgresql://postgres:postgres@localhost:6432/rideshare_sharded'),
      schema_search_path: 'rideshare'
    )
  end
end
