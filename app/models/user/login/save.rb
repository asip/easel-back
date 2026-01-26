# frozen_string_literal: true

# User::Login::Save module
module User::Login::Save
  extend ActiveSupport::Concern

  def enable_with(auth:)
    mutation = Mutations::User::EnableWithAuth.run(auth:, user: self)
    mutation.user
  end

  class_methods do
    def from(auth:, time_zone:)
      mutation = Mutations::User::FromAuthAndTimeZone.run(auth:, time_zone:)
      mutation.user
    end

    def find_or_create_from(auth:, time_zone:)
      mutation = Mutations::User::FindOrCreateFromAuthAndTimeZone.run(auth:, time_zone:)
      mutation.user
    end
  end
end
