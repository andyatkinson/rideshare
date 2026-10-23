class PgdogRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :pgdog, reading: :pgdog }
end
