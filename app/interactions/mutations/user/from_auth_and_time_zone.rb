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
    authentication = Queries::Authentication::FindFromAuth.run(auth: @auth)

    if authentication
      self.user = Queries::User::FindUser.run(user_id: authentication.user_id)
      Mutations::User::EnableWithAuth.run(auth: @auth, user:) if user.present?
    else
      mutation = Mutations::User::FindOrCreateFromAuthAndTimeZone.run(auth: @auth, time_zone: @time_zone)
      self.user = mutation.user
      Mutations::Authentication::CreateFromUserAndAuth.run(user:, auth: @auth)
    end

    user
  end

  private

  def user=(user)
    @user = user
  end
end
