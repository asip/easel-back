# frozen_string_literal: true

# manager
module Manager
  # Sessions Controller
  class SessionsController < Manager::ApplicationController
    skip_before_action :require_login, except: [:destroy]

    def new
      @user = Admin.new
    end

    def create
      params_user = user_params
      @user = login(params_user[:email], params_user[:password])
      if @user
        create_successful
      else
        create_failed(user_params: params_user)
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

    def create_successful
      redirect_to rails_admin_path
    end

    def create_failed(user_params:)
      success, @user = validate_login(user_params:)
      return if success

      flashes[:alert] = @user.errors.full_messages
      render :new
    end

    def validate_login(user_params:)
      user = Admin.find_by(email: user_params[:email])
      if user
        user.validate_password_on_login(user_params)
      else
        user = Admin.new(user_params)
        user.validate_email_on_login(user_params)
      end
      success = user.errors.empty?
      [success, user]
    end

    def user_params
      params.require(:admin).permit(:email, :password)
    end
  end
end
