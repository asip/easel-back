module Google
  module Oauth
    def self.auth_from(credential:, provider:)
      auth = {}
      auth[:info] = Google::Auth::IDTokens.verify_oidc(credential,
                                                       aud: Settings.google.client_id)
                                            .with_indifferent_access
      auth[:uid] = auth[:info][:sub]
      auth[:provider] = provider
      auth
    end
  end
end
