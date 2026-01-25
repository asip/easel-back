# frozen_string_literal: true

# Errors::Login module
module Errors::Login
  extend ActiveSupport::Concern

  def full_error_messages_on_login
    full_error_messages_for(%i[email password])
  end
end
