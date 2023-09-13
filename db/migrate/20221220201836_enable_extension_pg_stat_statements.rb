class EnableExtensionPgStatStatements < ActiveRecord::Migration[7.1]
  # PGSS = 'pg_stat_statements'
  #
  # def change
  #   # prereq: added to shared_preload_libraries='pg_stat_statements'
  #   enable_extension(PGSS) unless extension_enabled?(PGSS)
  # end


  # Replaced by:
  # sh scripts/setup_db.sh
  #
  # Extension should be enabled by superuser
end
