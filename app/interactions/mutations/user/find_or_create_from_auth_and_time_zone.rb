# frozen_string_literal: true

# Mutations::User::FindOrCreateFromAuthAndTimeZone class
class Mutations::User::FindOrCreateFromAuthAndTimeZone
  include Mutation

  attr_reader :user

  def initialize(auth:, time_zone:)
    @auth = auth
    @time_zone = time_zone
  end

  def execute
    email = @auth.email
    name = @auth.name

    self.user = ::User.unscoped.find_for_authentication(email:)

    unless user
      self.user = ::User.new(name:, email:, password: Devise.friendly_token[0, 20], time_zone: @time_zone)
    else
      user.deleted_at = nil
    end
    user.save!
    user
  end

  private

  def user=(user)
    @user = user
  end
end
