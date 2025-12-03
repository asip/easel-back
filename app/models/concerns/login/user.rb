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

      def auth_from(credential:, provider:, time_zone:)
        auth = {}
        auth[:info] = Google::Auth::IDTokens.verify_oidc(credential,
                                                         aud: Settings.google.client_id)
                                            .with_indifferent_access
        auth[:uid] = auth[:info][:sub]
        auth[:provider] = provider
        auth[:time_zone] = time_zone
        auth
      end

      def from(auth:)
        uid = auth[:uid]
        provider = auth[:provider]
        time_zone = auth[:time_zone]
        info = auth[:info] || {}

        # (認証レコードを検索)
        authentication = ::Authentication.find_by(uid: uid, provider: provider)

        if authentication
          user = ::User.unscoped.find_by(id: authentication.user_id)
          user.enable_with(info:) if user.present?
        else
          user = find_or_create_from(info:, time_zone:)
          ::Authentication.create_from(user:, provider:, uid:)
        end

        user
      end

      private

      def find_or_create_from(info:, time_zone:)
        email = info[:email]
        name = info[:name]

        user = ::User.unscoped.find_for_authentication(email:)

        unless user
          user = ::User.new(
            name: name,
            email: email,
            password: Devise.friendly_token[0, 20],
            time_zone:
          )
        else
          user.deleted_at = nil
        end
        user.save!
        user
      end
    end
  end
end
