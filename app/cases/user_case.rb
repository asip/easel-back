# frozen_string_literal: true

# User Case
class UserCase
  def detail_query(user_id:)
    User.find_by!(id: user_id)
  end

  def frames_query(user_id:)
    User.find_by!(id: user_id).frames.order('frames.created_at': 'desc')
  end

  def create_user(user_params:)
    user = User.new(user_params)
    result = user.save(context: :with_validation)
    [result, user]
  end

  def update_user(user:, user_params:)
    user.attributes = user_params
    # puts 'testtest'
    result = user.save(context: :with_validation)
    if result
      # puts user.saved_change_to_email?
      user.update_token
    end
    [result, user]
  end
end
