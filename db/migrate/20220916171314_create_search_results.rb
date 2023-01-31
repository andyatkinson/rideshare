class CreateSearchResults < ActiveRecord::Migration[7.0]
  def change
    create_view :search_results
  end
end
