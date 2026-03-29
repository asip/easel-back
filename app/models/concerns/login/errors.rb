# frozen_string_literal: true

# Login::Errors module
module Login::Errors
  extend ActiveSupport::Concern

  protected

  def error_properties_on_login
    %i[email password]
  end
end
