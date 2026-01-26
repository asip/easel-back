# frozen_string_literal: true

# Mutations::Authentication::CreateFromUserAndAuth class
class Mutations::Authentication::CreateFromUserAndAuth
  include Mutation

  attr_reader :authentication

  def initialize(user:, auth:)
    @user = user
    @auth = auth
  end

  def execute
    uid = @auth.uid
    provider = @auth.provider

    self.authentication = Authentication.new(user: @user, provider:, uid:)
    authentication.save!
  end

  private

  def authentication=(authentication)
    @authentication = authentication
  end
end
