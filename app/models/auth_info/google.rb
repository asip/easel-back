# frozen_string_literal: true

# auth_info/Google Module
module AuthInfo::Google
  extend ActiveSupport::Concern

  class_methods do
    def from_google(credential:, provider:)
      info = ::Google::Auth::IDTokens.verify_oidc(credential,
                                                  aud: Settings.google.client_id)
                                     .with_indifferent_access
      auth = AuthInfo.new({
        uid: info[:sub],
        provider:,
        email: info[:email],
        name: info[:name]
      })
      auth
    end
  end
end
