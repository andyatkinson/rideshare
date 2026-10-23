# Exercise bound INSERT/SELECT queries through PgDog, then independently inspect
# both backends to prove each row exists on exactly one shard.
require 'pg'
Rails.logger.level = Logger::WARN
model = TripPosition
rows = []
shards = []
begin
  (1..32).each do |trip_id|
    2.times do
      # Synthetic IDs isolate routing from parent-trip validation.
      row = model.new(trip_id: trip_id, position: '(1,2)')
      row.save!(validate: false)
      rows << row
      raise "Routed lookup failed" unless model.for_trip(trip_id).find(row.id).trip_id == trip_id
    end
  end
  shards = %w[shard_0 shard_1].map do |host|
    PG.connect(host: host, dbname: 'rideshare_sharded', user: 'postgres', password: 'postgres')
  end
  counts = [0, 0]
  placement = {}
  rows.each do |row|
    owners = shards.each_index.select do |index|
      shards[index].exec_params('SELECT id FROM rideshare.trip_positions WHERE trip_id = $1 AND id = $2', [row.trip_id, row.id]).ntuples == 1
    end
    raise "Row must exist on exactly one shard" unless owners.size == 1
    owner = owners.first
    raise "Trip samples split between shards" if placement.key?(row.trip_id) && placement[row.trip_id] != owner
    placement[row.trip_id] = owner
    counts[owner] += 1
  end
  raise 'Expected both shards to receive rows' unless counts.all?(&:positive?)
  ids = rows.map(&:id)
  raise 'Scatter query lost rows' unless model.where(id: ids).count == rows.size
  puts "Verified #{rows.size} inserts and keyed reads through PgDog."
  puts "Physical distribution: shard_0=#{counts[0]}, shard_1=#{counts[1]}; no duplicates; each trip stays on one shard."
  puts 'Cross-shard count verified.'
ensure
  rows.each { |row| model.where(trip_id: row.trip_id, id: row.id).delete_all }
  shards.each(&:close)
end
