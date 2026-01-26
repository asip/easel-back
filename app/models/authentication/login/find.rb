# frozen_string_literal: true

# authentication/login/Find Module
module Authentication::Login::Find
  extend ActiveSupport::Concern

  class_methods do
    def find_from(auth:)
      Queries::Authentication::FindFromAuth.run(auth:)
    end
  end
end
