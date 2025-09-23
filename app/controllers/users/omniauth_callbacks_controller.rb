# frozen_string_literal: true

# users / Omniauth Callbacks Controller
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include ActionController::Cookies

  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  def google_oauth2
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
    params.permit(:provider, :credential)
  end

  def callback_for(provider)
    auth = {}
    auth[:info] = Google::Auth::IDTokens.verify_oidc(params["credential"],
                                          aud: Settings.google.client_id)
    auth[:uid] = auth[:info]["sub"]
    auth[:provider] = provider
    auth[:time_zone] = request.headers["Time-Zone"]

    # puts auth

    user = User.from_omniauth(auth)
    sign_in(user, event: :authentication)

    render json: AccountResource.new(user).serializable_hash
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
