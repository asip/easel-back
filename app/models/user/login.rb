# frozen_string_literal: true

# user/Login module
module User::Login
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
  end
end
