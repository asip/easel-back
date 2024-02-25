# frozen_string_literal: true

# manager
module Manager
  # Sessions Controller
  class SessionsController < Manager::ApplicationController
    skip_before_action :require_login, except: [ :destroy ]
    before_action :authenticated, only: [ :new ]

    def new
      @user = Admin.new
    end

    def create
      params_form = form_params
      @user = login(params_form[:email], params_form[:password])
      if @user
        create_successful
      else
        create_failed(form_params: params_form)
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

    def authenticated
      redirect_to rails_admin_path if logged_in?
    end

    def create_successful
      redirect_to rails_admin_path
    end

    def create_failed(form_params:)
      success, @user = Admin.validate_login(form_params:)
      return if success

      flashes[:alert] = @user.full_error_messages_on_login
      render layout: false, content_type: "text/vnd.turbo-stream.html"
    end

    def form_params
      params.require(:admin).permit(:email, :password)
    end
  end
end
