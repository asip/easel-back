# frozen_string_literal: true

# Mutations::User::EnableWithAuth class
class Mutations::User::EnableWithAuth
  include Mutation

  attr_reader :user

  def initialize(auth:, user:)
    @auth = auth
    self.user = user
  end

  def execute
    email = @auth.email

    user.email = email if email.present? && user.email != email
    user.deleted_at = nil
    user.save!
    user
  end

  private

  def user=(user)
    @user = user
  end
end
