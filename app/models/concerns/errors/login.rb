# frozen_string_literal: true

# Errors::Login module
module Errors::Login
  extend ActiveSupport::Concern

  protected

  def error_properties_on_login
    %i[email password]
  end
end
