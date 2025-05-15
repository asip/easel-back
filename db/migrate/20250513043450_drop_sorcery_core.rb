class DropSorceryCore < ActiveRecord::Migration[8.0]
  def up
    change_table :users do |t|
      t.remove :crypted_password
      t.remove :salt
    end
  end

  def down
    change_table :users do |t|
      t.string :crypted_password
      t.string :salt
    end
  end
end
