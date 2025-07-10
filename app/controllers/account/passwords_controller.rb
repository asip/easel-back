# frozen_string_literal: true

# account / Passwords Controller
class Account::PasswordsController < ApplicationController
  # before_action :authenticate_user!

  def update
    if current_user.update_with_password(password_params)
      bypass_sign_in current_user
      render json: AccountResource.new(current_user).serializable_hash, status: :ok
    else
      render json: { errors: current_user.errors.to_hash(false) }.to_json, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
