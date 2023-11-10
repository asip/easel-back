# frozen_string_literal: true

# chage columnType id of tags
class ChangeColumnTypeIdOfTags < ActiveRecord::Migration[7.1]
  def up
    change_column :tags, :id, :bigint
  end

  def down
    change_column :tags, :id, :int
  end
end
