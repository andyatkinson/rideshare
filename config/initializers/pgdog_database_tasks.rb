require 'active_record/tasks/postgresql_database_tasks'

# PgDog keeps backend sessions open, preventing Rails from dropping its database.
# Reset the configured schema for test preparation, then let Rails load its dump.
module PgdogDatabaseTasks
  def purge
    return super unless db_config.name == 'pgdog'

    establish_connection
    configuration_hash.fetch(:schema_search_path).split(',').each do |schema|
      name = connection.quote_table_name(schema.strip)
      connection.execute("DROP SCHEMA IF EXISTS #{name} CASCADE")
      connection.execute("CREATE SCHEMA #{name}")
    end
  end
end

ActiveRecord::Tasks::PostgreSQLDatabaseTasks.prepend(PgdogDatabaseTasks)
