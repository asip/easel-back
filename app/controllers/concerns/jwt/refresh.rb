# frozen_string_literal: true

# Jwt::Refresh module
module Jwt::Refresh
  extend ActiveSupport::Concern

  included do
    before_action :refresh_token
  end

  protected

  def refresh_token
    return unless user_signed_in?

    token = request.headers["Authorization"]&.split(" ")&.last
    return unless token

    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    # Skip if there are 5 minutes or more remaining
    # (残り5分以上あればスキップ)
    return if payload["exp"] - Time.now.to_i > 5.minutes.to_i

    ## Update JTI → Old tokens that no longer match the JTI in the DB become invalid.
    ## (jti を更新 → DBのjtiと一致しなくなった古いトークンは無効になる)
    # current_user.update_column(:jti, SecureRandom.uuid)
    token = Warden::JWTAuth::UserEncoder.new.call(
      current_user, :user, nil
    ).first
    response.set_header("Authorization", "Bearer #{token}")
  end
end
