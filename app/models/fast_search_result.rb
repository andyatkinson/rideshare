class FastSearchResult < ApplicationRecord

  # this isn't strictly necessary, but it will prevent
  # rails from calling save, which would fail anyway.
  def readonly?
    true
  end

  def self.refresh(concurrently: false)
    Scenic.database.refresh_materialized_view(
      table_name,
      concurrently: concurrently,
      cascade: false
    )
  end
end
