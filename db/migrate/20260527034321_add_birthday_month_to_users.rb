class AddBirthdayMonthToUsers < ActiveRecord::Migration[7.2]
  def change
    # add_column :users, :birthday_month, :smallint
    safety_assured do
      execute(%{
                alter table users
                add column if not exists birthday_month smallint
              })
    end
  end
end
