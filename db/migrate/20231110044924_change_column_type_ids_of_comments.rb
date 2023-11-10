# frozen_string_literal: true

# change columnType ids of comments
class ChangeColumnTypeIdsOfComments < ActiveRecord::Migration[7.1]
  def up
    change_table :comments, bulk: true do |t|
      t.change :user_id, :bigint
      t.change :frame_id, :bigint
    end
  end

  def down
    change_table :comments, bulk: true do |t|
      t.change :user_id, :integer
      t.change :frame_id, :integer
    end
  end
end
