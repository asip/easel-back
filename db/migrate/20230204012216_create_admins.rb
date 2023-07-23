# frozen_string_literal: true

# CreateAdmins
class CreateAdmins < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :admins do |t|
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt

      t.integer :failed_logins_count, default: 0
      t.datetime :lock_expires_at, default: nil
      t.string :unlock_token, default: nil

      t.datetime :last_login_at, default: nil
      t.datetime :last_logout_at, default: nil
      t.datetime :last_activity_at, default: nil
      t.string :last_login_from_ip_address, default: nil

      t.timestamps
    end

    add_index :admins, :email, unique: true
    add_index :admins, :unlock_token
    add_index :admins, %i[last_logout_at last_activity_at]
  end
  # rubocop:enable Metrics/MethodLength
end
