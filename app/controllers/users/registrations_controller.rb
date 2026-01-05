# frozen_string_literal: true

# users / Registrations Controller
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  FORM_PARAMS = [ :name, :email, :password, :password_confirmation, :image, :profile, :time_zone ]

  # GET /resource/sign_up
  # def new
  #  super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  def destroy
    user_id = current_user&.id
    resource.discard
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    # set_flash_message! :notice, :destroyed
    yield resource if block_given?
    resource = User.unscoped.find_by!(id: user_id)
    respond_with_navigational(resource)
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  private

  def respond_with(resource, _opts = {})
    if resource.errors.empty?
      save_success(resource)
    else
      # puts resource.errors.to_hash(false)
      save_failed(resource)
    end
  end

  def save_success(resource)
    render json: AccountResource.new(resource).serializable_hash, status: :ok
  end

  def save_failed(resource)
    render json: { errors: resource.errors.to_hash(false) }.to_json, status: :unprocessable_content
  end

  def respond_with_navigational(resource)
    render json: AccountResource.new(resource).serializable_hash
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: FORM_PARAMS)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: FORM_PARAMS)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
