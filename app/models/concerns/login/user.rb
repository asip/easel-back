# frozen_string_literal: true

# login
module Login
  # User module
  module User
    extend ActiveSupport::Concern

    def self.validate_on_login(form_params:)
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

    def validate_password_on_login(form_params)
      password_ = form_params[:password]
      self.password = password_
      valid?(:login)
      errors.add(:password, I18n.t("action.login.invalid")) if password_.present?
    end

    def validate_email_on_login(form_params)
      valid?(:login)
      errors.delete(:email) if errors[:email].include?(I18n.t("errors.messages.taken"))
      errors.add(:email, I18n.t("action.login.invalid")) if form_params[:email].present?
    end

    def self.from_omniauth(auth)
      uid = auth[:uid]
      provider = auth[:provider]
      time_zone = auth[:time_zone]
      info = auth[:info] || {}

      # (認証レコードを検索)
      authentication = Authentication.find_by(uid: uid, provider: provider)

      if authentication
        info_email = info["email"]
        user = ::User.unscoped.find_by(id: authentication.user_id)
        update_user_info(user, email: info_email) if info_email.present?
      else
        user = find_or_create_from_omniauth(info, time_zone:)
        create_authentication_for_user(user, provider, uid)
      end

      user
    end

    private

    def self.update_user_info(user, email:)
      return unless user && email.present?
      if user.email != email
        user.email = email
      end
      user.deleted_at = nil
      user.save!
      user
    end

    def self.find_or_create_from_omniauth(info, time_zone:)
      email = info["email"]
      name = info["name"]

      user = ::User.unscoped.find_for_authentication(email: email)

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

    def self.create_authentication_for_user(user, provider, uid)
      authentication = Authentication.new(
        user: user,
        provider: provider,
        uid: uid
      )
      authentication.save!
    end
  end
end
