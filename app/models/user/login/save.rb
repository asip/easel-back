# frozen_string_literal: true

# User::Login::Save module
module User::Login::Save
  extend ActiveSupport::Concern

  def enable_with(auth:)
    email = auth.email

    self.email = email if email.present? && self.email != email
    self.deleted_at = nil
    self.save!
    self
  end

  class_methods do
    def from(auth:, time_zone:)
      authentication = Authentication.find_from(auth:)

      if authentication
        user = ::User.unscoped.find_by(id: authentication.user_id)
        user&.enable_with(auth:)
      else
        user = find_or_create_from(auth:, time_zone:)
        ::Authentication.create_from(user:, auth:)
      end

      user
    end

    def find_or_create_from(auth:, time_zone:)
      email = auth.email
      name = auth.name

      user = ::User.unscoped.find_for_authentication(email:)

      unless user
        user = ::User.new(name:, email:, password: Devise.friendly_token[0, 20], time_zone:)
      else
        user.deleted_at = nil
      end
      user.save!
      user
    end
  end
end
