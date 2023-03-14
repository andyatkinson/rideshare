#
# Steps:
# - export PGSLICE_URL
# - prep: ./bin/pgslice prep trip_positions created_at month
# - prep: pgslice prep
# - bin/rails runner "PgsliceHelper.new.add_partitions(table_name: 'trip_positions', past: 0, future: 3)"
#
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

  def retire_default_partition
  end

  def unretire_default_partition
  end

  private

  def log(line)
    Rails.logger.info "[pgslice] #{line}"
  end
end
