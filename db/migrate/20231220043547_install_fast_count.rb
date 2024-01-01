class InstallFastCount < ActiveRecord::Migration[7.1]
  def change
    # We are upgrading the gem, so we want to replace the current fast_count function
    safety_assured do
      execute("DROP FUNCTION IF EXISTS fast_count")
    end

    FastCount.install
  end
end
