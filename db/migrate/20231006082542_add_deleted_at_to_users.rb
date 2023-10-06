# frozen_string_literal: true

# add deleted_at to users
class AddDeletedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end
end
