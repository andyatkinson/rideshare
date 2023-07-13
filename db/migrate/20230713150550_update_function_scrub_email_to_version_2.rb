class UpdateFunctionScrubEmailToVersion2 < ActiveRecord::Migration[7.1]
  def change
    update_function :scrub_email, version: 2, revert_to_version: 1
  end
end
