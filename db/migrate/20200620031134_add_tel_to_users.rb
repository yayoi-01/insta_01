class AddTelToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tel, :integer
  end
end
