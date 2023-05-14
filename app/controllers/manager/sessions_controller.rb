# frozen_string_literal: true

# Admin
module Manager
  # Admin Controller
  class SessionsController < Manager::ApplicationController
    skip_before_action :require_login, except: [:destroy]

    def new
      @user = Admin.new
    end

    def create
      params_user = user_params
      @user = login(params_user[:email], params_user[:password])
      if @user
        redirect_to rails_admin_path
      else
        validate_login(params_user)
        render :new
      end
    end

    def show
      @user = current_user
    end

    def destroy
      logout
      redirect_to manager_login_path, status: :see_other
    end

    private

    def user_params
      params.require(:admin).permit(:email, :password)
    end

    def validate_login(params_user)
      @user = Admin.find_by(email: params_user[:email])
      if @user
        validate_password(params_user)
      else
        validate_email(params_user)
      end
    end

    def validate_password(params_user)
      @user.password = params_user[:password]
      @user.errors.add(:password, t('action.login.invalid')) if !@user.valid?(:login) && params_user[:password].present?
    end

    def validate_email(params_user)
      @user = Admin.new(params_user)
      @user.errors.add(:email, t('action.login.invalid')) if !@user.valid?(:login) && @user.email.present?
    end
  end
end
