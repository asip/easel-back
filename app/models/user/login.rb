# frozen_string_literal: true

# User::Login module
module User::Login
  extend ActiveSupport::Concern

  class_methods do
    def validate_on_login(form:)
      Login::Validate.run(form:, type: self)
    end
  end
end
