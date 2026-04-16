# frozen_string_literal: true

# users / Omniauth Callbacks Controller
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include ActionController::Cookies
  include HttpHeaders

  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  def callback
    sign_in(user, event: :authentication)

    render_account(account: user)
  end

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  private

  def auth_params
    @auth_params ||= params.permit(
      :provider, :credential, omniauth_callback: [ :provider, :credential ]
    ).to_h
  end

  def credential
    auth_params[:credential]
  end

  def provider
    auth_params[:provider]
  end

  def auth
    if provider == "google"
      AuthInfo.from_google(provider:, credential:)
    else
      nil
    end
  end

  def user
    @user ||= User.from(auth:, time_zone:)
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
