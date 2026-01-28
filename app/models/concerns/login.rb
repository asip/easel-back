# frozen_string_literal: true

# Login module
module Login
  extend ActiveSupport::Concern

  class_methods do
    def validate_on_login(form:)
      Validations::ValidateAccount.run(form:, type: self)
    end
  end
end
