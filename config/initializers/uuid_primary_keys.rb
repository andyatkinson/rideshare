require 'active_record/connection_adapters/postgresql_adapter'

# Rails 7.2 otherwise gives UUID primary keys a gen_random_uuid() default.
# Keep explicit defaults (including nil), and historical bigint migrations intact.
module UuidV7PrimaryKeys
  def primary_key(name, type = :primary_key, **options)
    options[:default] = -> { 'uuidv7()' } if type == :uuid && !options.key?(:default)
    super
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQL::ColumnMethods.prepend(UuidV7PrimaryKeys)
