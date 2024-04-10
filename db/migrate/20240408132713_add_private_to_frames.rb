# frozen_string_literal: true

# add private to frames
class AddPrivateToFrames < ActiveRecord::Migration[7.1]
  def change
    add_column :frames, :private, :boolean, default: false
  end
end
