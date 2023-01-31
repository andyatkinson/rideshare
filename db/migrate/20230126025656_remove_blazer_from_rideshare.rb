class RemoveBlazerFromRideshare < ActiveRecord::Migration[7.1]
  def change
    # No longer using Blazer
    drop_table(:blazer_queries)
    drop_table(:blazer_audits)
    drop_table(:blazer_dashboards)
    drop_table(:blazer_dashboard_queries)
    drop_table(:blazer_checks)
  end
end
