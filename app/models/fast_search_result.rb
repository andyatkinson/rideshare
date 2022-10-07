class FastSearchResult < ApplicationRecord
  belongs_to :searchable, polymorphic: true

  # this isn't strictly necessary, but it will prevent
  # rails from calling save, which would fail anyway.
  def readonly?
    true
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(
      table_name,
      concurrently: false,
      cascade: false
    )
  end
end
