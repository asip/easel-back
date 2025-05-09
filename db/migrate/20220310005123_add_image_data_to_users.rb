# frozen_string_literal: true

# add image_data to users
class AddImageDataToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :image_data, :text
  end
end
