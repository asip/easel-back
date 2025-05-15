require 'devise/jwt/test_helpers'

module ApiAuthHelper
  def authenticated_headers(request, user)
    auth_headers = Devise::JWT::TestHelpers.auth_headers({}, user)
    if request&.headers
      request.headers.merge!({ "Accept": "application/json" })
      request.headers.merge!(auth_headers)
    else
      {}.merge!({ "Accept": "application/json" }).merge!(auth_headers)
    end
  end
end

RSpec.configure do |config|
  config.include ApiAuthHelper, type: :request
end
