# frozen_string_literal: true

# add name to users
class AddNameToUsers < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/NotNullColumn
  def change
    add_column :users, :name, :string, null: false
  end
  # rubocop:enable Rails/NotNullColumn
end
