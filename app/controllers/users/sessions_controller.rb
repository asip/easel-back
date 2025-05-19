# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  before_action :configure_sign_in_params, only: [ :create ]

  @@form_params = [ :email, :password ]

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)
    # set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource) if resource
    # yield resource if block_given?
    respond_with resource
  end

  # DELETE /resource/sign_out
  # def destroy
  #   # user_id = current_user&.id
  #   signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
  #   set_flash_message! :notice, :signed_out if signed_out
  #   yield if block_given?
  #   # resource_ = User.unscoped.find_by!(id: user_id)
  #   # respond_to_on_destroy
  # end

  private

  def respond_with(resource, _opts = {})
    if resource
      login_success(resource)
    else
      login_failed
    end
  end

  def login_success(resource)
    render json: AccountResource.new(resource).serializable_hash, status: :ok
  end

  def login_failed
    success, user = User.validate_login(form_params: sign_in_params)
    return if success

    render json: {
      messages: user.full_error_messages_on_login
    }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end

  protected

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#login_failed" }
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: @@form_params)
  end
end
