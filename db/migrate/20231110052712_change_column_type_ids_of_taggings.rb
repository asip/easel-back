# frozen_string_literal: true

# channge columnType ids of taggings
class ChangeColumnTypeIdsOfTaggings < ActiveRecord::Migration[7.1]
  def up
    change_table :taggings, bulk: true do |t|
      t.change :id, :bigint
      t.change :tag_id, :bigint
      t.change :taggable_id, :bigint
      t.change :tagger_id, :bigint
    end
  end

  def down
    change_table :taggings, bulk: true do |t|
      t.change :id, :integer
      t.change :tag_id, :integer
      t.change :taggable_id, :integer
      t.change :tagger_id, :integer
    end
  end
end
