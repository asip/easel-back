# frozen_string_literal: true

# login
module Login
  # User module
  module User
    extend ActiveSupport::Concern

    def social_login?
      authentications.present?
    end

    def validate_password_on_login(form_params)
      password_ = form_params[:password]
      self.password = password_
      valid?(:login)
      errors.add(:password, I18n.t("action.login.invalid")) if password_.present? && !errors.include?(:password)
    end

    def validate_email_on_login(form_params)
      valid?(:login)
      errors.delete(:email) if errors[:email].include?(I18n.t("errors.messages.taken"))
      errors.add(:email, I18n.t("action.login.invalid")) if form_params[:email].present? && !errors.include?(:email)
    end

    class_methods do
      def validate_on_login(form_params:)
        user = ::User.find_for_authentication(email: form_params[:email])
        if user
          user.validate_password_on_login(form_params)
        else
          user = ::User.new(form_params)
          user.validate_email_on_login(form_params)
        end
        success = user.errors.empty?
        [ success, user ]
      end

      def from(auth:)
        uid = auth[:uid]
        provider = auth[:provider]
        time_zone = auth[:time_zone]
        info = auth[:info] || {}

        # (認証レコードを検索)
        authentication = Authentication.find_by(uid: uid, provider: provider)

        if authentication
          email = info[:email]
          user = ::User.unscoped.find_by(id: authentication.user_id)
          update(user:, email:) if email.present?
        else
          user = find_or_create_from(info:, time_zone:)
          create_authentication_for(user:, provider:, uid:)
        end

        user
      end

      private

      def update(user:, email:)
        return unless user && email.present?

        user.email = email if user.email != email
        user.deleted_at = nil
        user.save!
        user
      end

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

      def create_authentication_for(user:, provider:, uid:)
        authentication = Authentication.new(
          user: user,
          provider: provider,
          uid: uid
        )
        authentication.save!
      end
    end
  end
end
