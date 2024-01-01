# frozen_string_literal: true

# manager
module Manager
  # Application Controller
  class ApplicationController < ActionController::Base
    include Locale::AutoDetect
    include Flashes

    before_action :require_login

    private

    def not_authenticated
      redirect_to main_app.manager_login_path # main_appのプレフィックスをつける
    end

    # Overwrite Sorcery's handle unverified request
    def handle_unverified_request
      cookies[:remember_me_token] = nil
      @current_user = nil
      return reset_session if current_user.blank?

      raise ActionController::InvalidAuthenticityToken, warning_message
    end

    def user_class
      @user_class ||= Admin.to_s.constantize
    end
  end
end
