# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  before_action :configure_sign_in_params, only: [ :create ]

  @@form_params = [ :email, :password ]

  # POST /resource/sign_in
  # def create
  #   super
  # end

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
    login_sucess(resource)
  end

  def login_sucess(resource)
    render json: AccountResource.new(resource).serializable_hash, status: :ok
  end

  # def login_failed(form_params:)
  #   success, user = User.validate_login(form_params:)
  #   return if success
  #
  #   render json: {
  #     messages: user.full_error_messages_on_login
  #   }, status: :unprocessable_entity
  # end

  def respond_to_on_destroy
    head :no_content
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: @@form_params)
  end
end
