class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # connects_to database: {
  #   writing: :rideshare,
  #   reading: :rideshare_replica
  # }
end
