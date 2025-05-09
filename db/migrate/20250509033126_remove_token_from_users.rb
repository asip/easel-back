class RemoveTokenFromUsers < ActiveRecord::Migration[8.0]
  def up
    remove_column :users, :token
  end
  def down
    add_column :users, :token, :string
    add_index :users, :token, unique: true
  end
end
