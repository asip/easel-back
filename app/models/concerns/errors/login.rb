# frozen_string_literal: true

# errors
module Errors
  # Login module
  module Login
    extend ActiveSupport::Concern

    def full_error_messages_on_login
      full_error_messages_for(%i[email password])
    end
  end
end
