class CreateExtensionPgCron < ActiveRecord::Migration[7.1]
  PG_CRON = 'pg_cron'

  def change
    # prereqs: https://github.com/citusdata/pg_cron
    # - build from source
    # - in postgresql.conf
    #   * add to shared_preload_libraries='pg_cron'
    #   * set cron.database_name = 'rideshare_development'
    #
    enable_extension(PG_CRON) unless extension_enabled?(PG_CRON)
  end
end
