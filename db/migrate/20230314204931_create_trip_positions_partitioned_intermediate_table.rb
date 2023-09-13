class CreateTripPositionsPartitionedIntermediateTable < ActiveRecord::Migration[7.1]
  def change
    safety_assured do # skipping Strong Migrations safeguard
      execute <<-SQL.squish
      BEGIN;

      CREATE TABLE "rideshare_schema"."trip_positions_intermediate" (
        LIKE "public"."trip_positions"
        INCLUDING DEFAULTS
        INCLUDING CONSTRAINTS
        INCLUDING STORAGE
        INCLUDING COMMENTS
      ) PARTITION BY RANGE ("created_at");

      COMMENT ON TABLE "rideshare_schema"."trip_positions_intermediate"
      IS 'column:created_at,period:month,cast:date,version:3';

      COMMIT;
      SQL
    end
  end
end
