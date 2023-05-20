class ChangeUsersNameEmailIndex < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.remove_index %i[name email]
      t.index %i[name email], unique: false
    end
  end
end
