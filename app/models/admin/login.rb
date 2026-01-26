# frozen_string_literal: true

# Admin::Login module
module Admin::Login
  extend ActiveSupport::Concern

  class_methods do
    def validate_on_login(form:)
      Login::Validate.run(form:, type: self)
    end
  end
end
