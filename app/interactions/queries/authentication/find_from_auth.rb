# frozen_string_literal: true

# Queries::Authentication::FindFromAuth class
class Queries::Authentication::FindFromAuth
  include Query

  def initialize(auth:)
    @auth = auth
  end

  def execute
    uid = @auth.uid
    provider = @auth.provider

    # Find authentication records
    # (認証レコードを検索)
    Authentication.find_by(uid:, provider:)
  end
end
