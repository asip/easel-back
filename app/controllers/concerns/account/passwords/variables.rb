# frozen_string_literal: true

# Account::Passwords::Variables module
module Account::Passwords::Variables
  extend ActiveSupport::Concern

  protected

  def form_params
    @form_params ||= params.expect(
      user: [ :current_password, :password, :password_confirmation ]
    ).to_h
  end
end
