class DropSorceryActivityLogging < ActiveRecord::Migration[8.0]
  def up
    remove_column :users, :last_login_at
    remove_column :users, :last_logout_at
    remove_column :users, :last_activity_at
    remove_column :users, :last_login_from_ip_address
  end

  def down
    add_column :users, :last_login_at, :datetime, default: nil
    add_column :users, :last_logout_at, :datetime, default: nil
    add_column :users, :last_activity_at, :datetime, default: nil
    add_column :users, :last_login_from_ip_address, :string, default: nil

    add_index :users, %i[last_logout_at last_activity_at]
  end
end
