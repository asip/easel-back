# frozen_string_literal: true

# Manager
module Manager
  # Admin Controller
  class ApplicationController < ActionController::Base
    before_action :require_login

    def current_user
      Admin.find_by(id: session[:user_id])
    end

    private

    def not_authenticated
      redirect_to main_app.manager_login_path #main_appのプレフィックスをつける
    end

    def user_class
      @user_class ||= Admin.to_s.constantize
    end
  end
end
