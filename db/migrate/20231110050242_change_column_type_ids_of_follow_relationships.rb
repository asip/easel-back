# frozen_string_literal: true

# change columnType ids of follow_relationships
class ChangeColumnTypeIdsOfFollowRelationships < ActiveRecord::Migration[7.1]
  def up
    change_table :follow_relationships, bulk: true do |t|
      t.change :follower_id, :bigint
      t.change :followee_id, :bigint
    end
  end

  def down
    change_table :follow_relationships, bulk: true do |t|
      t.change :follower_id, :integer
      t.change :followee_id, :integer
    end
  end
end
