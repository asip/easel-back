# frozen_string_literal: true

# account / Passwords Controller
class Account::PasswordsController < ApplicationController
  include Account::Passwords::Variables

  def update
    if current_user.update_with_password(form_params)
      bypass_sign_in current_user
      render_account(current_user)
    else
      render_errors(current_user)
    end
  end
end
