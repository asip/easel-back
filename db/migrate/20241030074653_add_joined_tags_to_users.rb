class AddJoinedTagsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :frames, :joined_tags, :string
  end
end
