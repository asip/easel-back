# frozen_string_literal: true

# change columnType user_id of frames
class ChangeColumnUserIdOfFrames < ActiveRecord::Migration[7.1]
  def up
    change_column :frames, :user_id, :bigint
  end

  def down
    change_column :frames, :user_id, :integer
  end
end
