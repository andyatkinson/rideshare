class CreateFastSearchResults < ActiveRecord::Migration[7.0]
  def change
    create_view :fast_search_results, materialized: true
  end
end
