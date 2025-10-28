# frozen_string_literal: true

# devise
module Devise
  # Failure App
  class FailureApp
    # def http_auth
    #  self.status = 401
    #  self.headers["WWW-Authenticate"] = %(Basic realm=#{Devise.http_authentication_realm.inspect}) if http_auth_header?
    #  self.content_type = request.format.to_s
    #  self.response_body = http_auth_body
    #  puts http_auth_body
    # end

    protected

    def http_auth_body
      return i18n_message unless request_format
      format = request_format
      # puts format
      method = "to_#{format}"
      # puts method
      if format == :xml
        { error: i18n_message }.to_xml(root: "errors")
      elsif format == :json
        { title: "Unauthorized", errors: [ i18n_message ] }.to_json
      elsif {}.respond_to?(method)
        { error: i18n_message }.send(method)
      else
        i18n_message
      end
    end
  end
end
