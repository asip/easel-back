# frozen_string_literal: true

# Users Case
class UsersCase
  def create_user(form_params:)
    user = User.new(form_params)
    success = user.save(context: :with_validation)
    [success, user]
  end

  def update_user(user:, form_params:)
    user.attributes = form_params
    # puts 'testtest'
    success = user.valid?(:with_validation)
    if success
      # puts user.saved_change_to_email?
      user.save!(context: :with_validation)
      user.update_token
    end
    [success, user]
  end

  def find_query(user_id:)
    User.find_by!(id: user_id)
  end

  def frames_query(user_id:)
    User.find_by!(id: user_id).frames.order('frames.created_at': 'desc')
  end
end
