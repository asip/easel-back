class RemoveSorceryColumnsFromAdmins < ActiveRecord::Migration[8.0]
  def up
    change_table :admins do |t|
      t.remove :crypted_password
      t.remove :salt

      t.remove :failed_logins_count
      t.remove :lock_expires_at
      t.remove :unlock_token

      t.remove :last_login_at
      t.remove :last_logout_at
      t.remove :last_activity_at
      t.remove :last_login_from_ip_address
    end
  end

  def down
    change_table :admins do |t|
      t.string :crypted_password
      t.string :salt

      t.integer :failed_logins_count, default: 0
      t.datetime :lock_expires_at, default: nil
      t.string :unlock_token, default: nil

      t.datetime :last_login_at, default: nil
      t.datetime :last_logout_at, default: nil
      t.datetime :last_activity_at, default: nil
      t.string :last_login_from_ip_address, default: nil
    end

    add_index :admins, :unlock_token
    add_index :admins, %i[last_logout_at last_activity_at]
  end
end
