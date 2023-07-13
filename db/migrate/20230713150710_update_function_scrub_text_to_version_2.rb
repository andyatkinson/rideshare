class UpdateFunctionScrubTextToVersion2 < ActiveRecord::Migration[7.1]
  def change
    update_function :scrub_text, version: 2, revert_to_version: 1
  end
end
