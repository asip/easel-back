# frozen_string_literal: true

# Queries::Users::FindUser class
class Queries::Users::FindUser
  include Query

  def initialize(user_id:)
    @user_id = user_id
  end

  def execute
    User.with_discarded.find_by!(id: @user_id)
  end
end
