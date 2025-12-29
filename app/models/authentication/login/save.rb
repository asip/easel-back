# frozen_string_literal: true

# authentication/login/Save Module
module Authentication::Login::Save
  extend ActiveSupport::Concern

  class_methods do
    def create_from(user:, auth:)
      uid = auth.uid
      provider = auth.provider

      authentication = ::Authentication.new(user:, provider:, uid:)
      authentication.save!
    end
  end
end
