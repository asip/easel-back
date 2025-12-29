# frozen_string_literal: true

# authentication/login/Find Module
module Authentication::Login::Find
  extend ActiveSupport::Concern

  class_methods do
    def find_from(auth:)
      uid = auth.uid
      provider = auth.provider

      # (認証レコードを検索)
      ::Authentication.find_by(uid:, provider:)
    end
  end
end
