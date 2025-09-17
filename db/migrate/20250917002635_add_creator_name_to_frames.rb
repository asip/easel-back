class AddCreatorNameToFrames < ActiveRecord::Migration[8.0]
  def change
    add_column :frames, :creator_name, :string
  end
end
