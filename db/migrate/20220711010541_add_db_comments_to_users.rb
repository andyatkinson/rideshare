class AddDbCommentsToUsers < ActiveRecord::Migration[7.0]
  def change
    comment = 'sensitive_fields|first_name:scrub_text,last_name:scrub_text,email:scrub_email'
    change_table_comment :users, from: nil, to: comment

  end
end
