# frozen_string_literal: true

# login
module Login
  # User module
  module User
    extend ActiveSupport::Concern

    def social_login?
      authentications.present?
    end

    def validate_password_on_login(form)
      password_ = form[:password]
      self.password = password_
      valid?(:login)
      errors.add(:password, I18n.t("action.login.invalid")) if password_.present? && !errors.include?(:password)
    end

    def validate_email_on_login(form)
      valid?(:login)
      errors.delete(:email) if errors[:email].include?(I18n.t("errors.messages.taken"))
      errors.add(:email, I18n.t("action.login.invalid")) if form[:email].present? && !errors.include?(:email)
    end

    def enable_with(info:)
      email = info[:email]

      self.email = email if email.present? && self.email != email
      self.deleted_at = nil
      self.save!
      self
    end

    class_methods do
      def validate_on_login(form:)
        user = ::User.find_for_authentication(email: form[:email])
        if user
          user.validate_password_on_login(form)
        else
          user = ::User.new(form)
          user.validate_email_on_login(form)
        end
        success = user.errors.empty?
        [ success, user ]
      end

      def from(auth:, time_zone:)
        uid = auth[:uid]
        provider = auth[:provider]
        info = auth[:info] || {}

        # (認証レコードを検索)
        authentication = ::Authentication.find_by(uid:, provider:)

        if authentication
          user = ::User.unscoped.find_by(id: authentication.user_id)
          user.enable_with(info:) if user.present?
        else
          user = find_or_create_from(info:, time_zone:)
          ::Authentication.create_from(user:, provider:, uid:)
        end

        user
      end

      def find_or_create_from(info:, time_zone:)
        email = info[:email]
        name = info[:name]

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
end
