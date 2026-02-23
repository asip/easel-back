# frozen_string_literal: true

# users / Omniauth Callbacks Controller
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include ActionController::Cookies
  include TimeZone::Detect

  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  def google
    callback_for(:google)
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

  def callback_for(provider)
    auth = AuthInfo.from_google(provider:, credential: auth_params[:credential])
    user = User.from(auth:, time_zone:)
    sign_in(user, event: :authentication)

    render json: AccountResource.new(user).serializable_hash
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
