class AddLocationsCityState < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :city, :string
    add_column :locations, :state, 'character(2)'
  end
end
