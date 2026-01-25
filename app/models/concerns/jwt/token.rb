# frozen_string_literal: true

# jwt
module Jwt::Token
  extend ActiveSupport::Concern

  included do
    attr_reader :token
  end

  def assign_token(token_)
    @token = token_
  end

  def update_token
    # return unless saved_change_to_email?
  end

  def reset_token
    @token = nil
  end
end
