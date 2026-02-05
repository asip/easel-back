# frozen_string_literal: true

# account / Passwords Controller
class Account::PasswordsController < ApplicationController
  def update
    if current_user.update_with_password(password_params)
      bypass_sign_in current_user
      render json: AccountResource.new(current_user).serializable_hash, status: :ok
    else
      render json: Oj.dump({ errors: current_user.errors.to_hash(false) }), status: :unprocessable_content
    end
  end

  private

  def password_params
    @password_params ||= params.expect(
      user: [ :current_password, :password, :password_confirmation ]
    ).to_h
  end
end
