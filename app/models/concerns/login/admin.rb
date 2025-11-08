# frozen_string_literal: true

# login
module Login
  # Admin module
  module Admin
    extend ActiveSupport::Concern

    def full_error_messages_on_login
      full_error_messages_for(%i[email password])
    end

    def validate_password_on_login(form_params)
      password_ = form_params[:password]
      self.password = password_
      valid?
      errors.add(:password, I18n.t("action.login.invalid")) if password_.present? && !errors.include?(:password)
    end

    def validate_email_on_login(form_params)
      valid?
      errors.add(:email, I18n.t("action.login.invalid")) if form_params[:email].present? && !errors.include?(:email)
    end

    class_methods do
      def validate_on_login(form_params:)
        admin = ::Admin.find_for_authentication(email: form_params[:email])
        if admin
          admin.validate_password_on_login(form_params)
        else
          admin = ::Admin.new(form_params)
          admin.validate_email_on_login(form_params)
        end
        success = admin.errors.empty?
        [ success, admin ]
      end
    end
  end
end
