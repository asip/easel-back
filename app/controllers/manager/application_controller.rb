# frozen_string_literal: true

# manager
module Manager
  # Application Controller
  class ApplicationController < ActionController::Base
    include Locale::AutoDetect

    before_action :switch_locale
    before_action :require_login

    private

    def not_authenticated
      redirect_to main_app.manager_login_path # main_appのプレフィックスをつける
    end

    def user_class
      @user_class ||= Admin.to_s.constantize
    end
  end
end
