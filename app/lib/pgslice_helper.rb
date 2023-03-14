#
# Steps:
# - export PGSLICE_URL
# - prep: ./bin/pgslice prep trip_positions created_at month
# - prep: pgslice prep
# - bin/rails runner "PgsliceHelper.new.add_partitions(table_name: 'trip_positions', past: 0, future: 3)"
#
# Prep:
# Retire default
# - bin/rails runner "PgsliceHelper.new.retire_default_partition(table_name: 'trip_positions')"
#
# To test app compatibility:
# - Make sure latest changes from dev DB are applied: `bin/rails db:test:prepare`
# - change PGSLICE_URL in .env, specify test DB
# - run `bin/rails test`
class PgsliceHelper
  def add_partitions(table_name:, intermediate: true, past:, future:, dry_run: true)
    cmd = %(./bin/pgslice add_partitions #{table_name} \
    #{"--intermediate " if intermediate} \
    #{"--past #{past}" if past} \
    #{"--future #{future}" if future} \
    #{"--dry-run" if dry_run} \
    ).squish
    log("dry_run=#{dry_run} invoking: #{cmd}")
    system(cmd)
  end

  def fill
  end

  def analyze
  end

  def swap
  end

  def unswap
  end

  # default partitions cannot be detached concurrently
  # "ERROR:  cannot detach partitions concurrently when a default partition exists"
  def retire_default_partition(table_name:, dry_run: false)
    table_name = "#{table_name}_intermediate" # assumes intermediate table
    partition_name = "#{table_name}_default"
    retired_name = "#{partition_name}_retired"

    sql = %(
      BEGIN;

      ALTER TABLE #{table_name} \
      DETACH PARTITION #{partition_name};

      ALTER TABLE #{partition_name}
      RENAME TO #{retired_name}
    ).squish

    cmd = %(psql $PGSLICE_URL -c '#{sql}')
    log("detaching and retiring dry_run=#{dry_run} cmd=#{cmd}")
    log("cmd=#{cmd}")
    system(cmd) unless dry_run
  end

  def unretire_default_partition(table_name:, dry_run: false)
    table_name = "#{table_name}_intermediate" # assumes intermediate table
    partition_name = "#{table_name}_default"
    retired_name = "#{partition_name}_retired"

    sql = %(
      BEGIN;

      ALTER TABLE #{retired_name}
      RENAME TO #{partition_name};

      ALTER TABLE #{table_name}
      ATTACH PARTITION #{partition_name}
      DEFAULT;

      COMMIT;
    ).squish
    cmd = %(psql $PGSLICE_URL -c '#{sql}')
    log("unretiring and attaching. dry_run=#{dry_run}")
    log("cmd=#{cmd}")
    system(cmd) unless dry_run
  end

  private

  def log(line)
    Rails.logger.info "[pgslice] #{line}"
  end
end
