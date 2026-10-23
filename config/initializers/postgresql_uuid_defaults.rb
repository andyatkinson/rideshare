require 'active_record/connection_adapters/postgresql_adapter'

# Rails 7.2 hardcodes v4 for UUID primary keys. Use PostgreSQL 18's generator
# for UUID keys and ordinary UUID columns, while respecting explicit defaults.
module PostgresqlUuidPrimaryKeys
  def primary_key(name, type = :primary_key, **options)
    options[:default] = -> { 'uuidv7()' } if type == :uuid && !options.key?(:default)
    super
  end
end

module PostgresqlUuidColumns
  def new_column_definition(name, type, **options)
    options[:default] = -> { 'uuidv7()' } if type == :uuid && !options.key?(:default)
    super
  end
end

# A reference copies another row's ID; it must not generate a new identity.
module UuidReferenceDefaults
  def initialize(name, polymorphic: false, index: true, foreign_key: false, type: :bigint, **options)
    options[:default] = nil if type == :uuid && !options.key?(:default)
    super
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQL::ColumnMethods.prepend(PostgresqlUuidPrimaryKeys)
ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition.prepend(PostgresqlUuidColumns)
ActiveRecord::ConnectionAdapters::ReferenceDefinition.prepend(UuidReferenceDefaults)
