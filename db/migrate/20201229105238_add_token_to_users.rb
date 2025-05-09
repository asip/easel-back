# frozen_string_literal: true

# add token to users
class AddTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :token, :string
    add_index :users, :token, unique: true
  end
end
