require 'rails/generators'
require 'rails/generators/active_record'

class UuidConversionGenerator < ActiveRecord::Generators::Base
  argument :name, type: :string, default: 'conversion'

  source_root File.expand_path('templates', __dir__)

  def create_conversion
    migration_template 'convert_primary_keys_to_uuid.rb.tt', 'db/migrate/convert_primary_keys_to_uuid.rb'
  end
end
