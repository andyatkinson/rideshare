require 'test_helper'

class PostgresqlUuidDefaultsTest < ActiveSupport::TestCase
  test 'UUID keys and columns generate v7 while references and explicit defaults are preserved' do
    connection = ActiveRecord::Base.connection
    connection.create_table :uuid_defaults_probe, id: :uuid do |t|
      t.uuid :token
      t.uuid :manual, default: nil
      t.uuid :legacy, default: -> { 'gen_random_uuid()' }
      t.references :parent, type: :uuid, index: false
    end
    connection.add_column :uuid_defaults_probe, :added_token, :uuid

    row = connection.select_one(<<~SQL)
      INSERT INTO uuid_defaults_probe DEFAULT VALUES
      RETURNING uuid_extract_version(id) AS id_version,
                uuid_extract_version(token) AS token_version,
                uuid_extract_version(added_token) AS added_version,
                uuid_extract_version(legacy) AS legacy_version,
                manual, parent_id
    SQL
    assert_equal [7, 7, 7, 4], row.values_at('id_version', 'token_version', 'added_version', 'legacy_version')
    assert_nil row['manual']
    assert_nil row['parent_id']
  ensure
    connection&.drop_table :uuid_defaults_probe, if_exists: true
  end
end
