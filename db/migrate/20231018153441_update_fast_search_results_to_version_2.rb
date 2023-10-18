class UpdateFastSearchResultsToVersion2 < ActiveRecord::Migration[7.1]
  def change
    update_view :fast_search_results,
      version: 2,
      revert_to_version: 1,
      materialized: true
  end
end
