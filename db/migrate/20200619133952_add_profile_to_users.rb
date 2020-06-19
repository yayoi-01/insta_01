class AddProfileToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile, :text
    add_index :users, :profile
  end
end
