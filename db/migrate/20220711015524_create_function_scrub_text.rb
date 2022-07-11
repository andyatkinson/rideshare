class CreateFunctionScrubText < ActiveRecord::Migration[7.0]
  def change
    create_function :scrub_text
  end
end
