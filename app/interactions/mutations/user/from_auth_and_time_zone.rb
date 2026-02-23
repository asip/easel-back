# frozen_string_literal: true

# Mutations::User::FromAuthAndTimeZone class
class Mutations::User::FromAuthAndTimeZone
  include Mutation

  attr_reader :user

  def initialize(auth:, time_zone:)
    @auth = auth
    @time_zone = time_zone
  end

  def execute
    authentication = Authentication.find_from(auth: @auth)

    if authentication
      self.user = Queries::User::FindUser.run(user_id: authentication.user_id)
      user&.enable_with(auth: @auth)
    else
      self.user = User.find_or_create_from(auth: @auth, time_zone: @time_zone)
      Authentication.create_from(user:, auth: @auth)
    end

    user
  end

  private

  def user=(user)
    @user = user
  end
end
