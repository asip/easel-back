# frozen_string_literal: true

# Users Case
class UsersCase
  def detail_query(user_id:)
    User.find_by!(id: user_id)
  end

  def frames_query(user_id:)
    User.find_by!(id: user_id).frames.order('frames.created_at': 'desc')
  end

  def create_user(user_params:)
    user = User.new(user_params)
    success = user.save(context: :with_validation)
    [success, user]
  end

  def update_user(user:, user_params:)
    user.attributes = user_params
    # puts 'testtest'
    success = user.save(context: :with_validation)
    if success
      # puts user.saved_change_to_email?
      user.update_token
    end
    [success, user]
  end
end
