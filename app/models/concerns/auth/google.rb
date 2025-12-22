# frozen_string_literal: true

# auth
module Auth
  # Google module
  module Google
    def self.auth_from(credential:, provider:)
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
