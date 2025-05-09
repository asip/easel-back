# frozen_string_literal: true

# add user_id to frames
class AddUserIdToFrames < ActiveRecord::Migration[5.1]
  def change
    add_column :frames, :user_id, :integer
  end
end
