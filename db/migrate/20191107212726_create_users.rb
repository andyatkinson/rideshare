class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    # index: Rails adds PK index
    create_table :users do |t|
      t.string :first_name, null: false # index: no
      t.string :last_name, null: false # index: no
      t.string :email, null: false, index: true, unique: true # index: true
      t.string :type, null: false # index: maybe in future, partitioning

      t.timestamps # nullability: Rails adds null: false
    end
  end
end
