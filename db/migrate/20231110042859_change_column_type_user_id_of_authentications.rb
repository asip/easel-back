# frozen_string_literal: true

# change columnType user_id of authentications
class ChangeColumnTypeUserIdOfAuthentications < ActiveRecord::Migration[7.1]
  def up
    change_column :authentications, :user_id, :bigint
  end

  def down
    change_column :authentications, :user_id, :inreger
  end
end
