# Safe by default, add dry_run=false when ready
# Prep:
# export PGSLICE_URL
# - Retire default
# - bin/rails runner "PgsliceHelper.new.retire_default_partition(table_name: 'trip_positions')"
# - bin/rails runner "PgsliceHelper.new.add_partitions(table_name: 'trip_positions', past: 0, future: 3, dry_run: false)"
# - bin/rails runner "PgsliceHelper.new.fill(table_name: 'trip_positions', from_date: '2021-01-01')"
# - bin/rails runner "PgsliceHelper.new.analyze(table_name: 'trip_positions')"
#
# Data export (Safe by default, add dry_run=false when ready)
# - bin/rails runner "PgsliceHelper.new.dump_retired_table(table_name: 'trip_positions')"
# - bin/rails runner "PgsliceHelper.new.drop_retired_table(table_name: 'trip_positions')"
#
# To test app compatibility:
# - Make sure latest changes from dev DB are applied: `bin/rails db:test:prepare`
# - change PGSLICE_URL in .env, specify test DB
# - run `bin/rails test`
class PgsliceHelper
  DEFAULT_COLUMN = 'created_at'

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

  def fill(table_name:, partition_column: DEFAULT_COLUMN, swapped: false, from_date:)
    cmd = %(./bin/pgslice fill #{table_name}
    #{"--where \"date(#{partition_column}) >= date('#{from_date}')\"" if from_date}
    #{"--swapped" if swapped}
    ).squish
    log("fill cmd: #{cmd}")
    system(cmd)
  end

  def analyze(table_name:)
    cmd = %(./bin/pgslice analyze #{table_name}).squish
    log("cmd: #{cmd}")
    system(cmd)
  end

  def swap(table_name:)
    cmd = %(./bin/pgslice swap #{table_name}).squish
    log("cmd: #{cmd}")
    system(cmd)
  end

  def unswap(table_name:)
    cmd = %(./bin/pgslice unswap #{table_name}).squish
    log("cmd: #{cmd}")
    system(cmd)
  end

  # default partitions cannot be detached concurrently
  # "ERROR:  cannot detach partitions concurrently when a default partition exists"
  def retire_default_partition(table_name:, dry_run: true)
    tbl_name = "#{table_name}_intermediate" # assumes intermediate table
    partition_name = "#{tbl_name}_default"
    retired_name = "#{partition_name}_retired"

    sql = %(
      BEGIN;

      ALTER TABLE #{tbl_name} \
      DETACH PARTITION #{partition_name};

      ALTER TABLE #{partition_name}
      RENAME TO #{retired_name};

      COMMIT;
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

  def dump_retired_table(table_name:, dry_run: true)
    retired_name = "#{table_name}_retired"
    dump_name = "#{retired_name}.dump"
    cmd = %(pg_dump -c -Fc -t #{retired_name} $PGSLICE_URL > #{dump_name})
    log("cmd=#{cmd}")
    system(cmd) unless dry_run
  end

  def drop_retired_table(table_name:, dry_run: true)
    retired_name = "#{table_name}_retired"
    cmd = %(psql -c 'DROP TABLE #{retired_name}' $PGSLICE_URL)
    log("cmd: #{cmd}")
    system(cmd) unless dry_run
  end

  private

  def log(line)
    Rails.logger.info "[pgslice] #{line}"
  end
end
