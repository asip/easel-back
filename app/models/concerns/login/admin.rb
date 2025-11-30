# frozen_string_literal: true

# login
module Login
  # Admin module
  module Admin
    extend ActiveSupport::Concern

    def validate_password_on_login(form)
      password_ = form[:password]
      self.password = password_
      valid?
      errors.add(:password, I18n.t("action.login.invalid")) if password_.present? && !errors.include?(:password)
    end

    def validate_email_on_login(form)
      valid?
      errors.add(:email, I18n.t("action.login.invalid")) if form[:email].present? && !errors.include?(:email)
    end

    class_methods do
      def validate_on_login(form:)
        admin = ::Admin.find_for_authentication(email: form[:email])
        if admin
          admin.validate_password_on_login(form)
        else
          admin = ::Admin.new(form)
          admin.validate_email_on_login(form)
        end
        success = admin.errors.empty?
        [ success, admin ]
      end
    end
  end
end
