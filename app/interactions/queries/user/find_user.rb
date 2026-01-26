# frozen_string_literal: true

# Queries::User::FindUser class
class Queries::User::FindUser
  include Query

  def initialize(user_id:)
    @user_id = user_id
  end

  def execute
    User.with_discarded.find_by!(id: @user_id)
  end
end
