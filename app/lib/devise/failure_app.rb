# frozen_string_literal: true

# devise
module Devise
  # Failure App
  class FailureApp
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
        Oj.dump({ title: "Unauthorized", errors: [ i18n_message ] })
      elsif {}.respond_to?(method)
        { error: i18n_message }.send(method)
      else
        i18n_message
      end
    end
  end
end
