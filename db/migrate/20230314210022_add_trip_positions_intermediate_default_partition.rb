class AddTripPositionsIntermediateDefaultPartition < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      execute <<-SQL.squish
      CREATE TABLE "trip_positions_intermediate_default"
      PARTITION OF "trip_positions_intermediate"
      DEFAULT;

      ALTER TABLE "trip_positions_intermediate_default" ADD PRIMARY KEY ("id");
      SQL
    end
  end
end
