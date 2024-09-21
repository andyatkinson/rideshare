#
# Replace begin_db_transaction to ONLY create READ ONLY
# transactions. This would be a bad idea in a real app, which would
# need to read and write data. This is only for a demonstration.
#

module Patches::ActiveRecordPatches
  module ::ActiveRecord::ConnectionAdapters::PostgreSQL::DatabaseStatements
    def begin_db_transaction
      # Replaces:
      # internal_execute("BEGIN", "TRANSACTION", allow_retry: true, materialize_transactions: false)
      internal_execute("BEGIN", "TRANSACTION READ ONLY", allow_retry: true, materialize_transactions: false)
    end
  end
end
