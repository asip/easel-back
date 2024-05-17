class RemoveNameEmailIndexFromUsers < ActiveRecord::Migration[7.1]
  def up
    change_table :users, bulk: true do |t|
      t.remove_index %i[name email]
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.index %i[name email], unique: false
    end
  end
end
