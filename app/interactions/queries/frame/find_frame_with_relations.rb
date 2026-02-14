# frozen_string_literal: true

# Queries::Frame::FindFrameWithRelations class
class Queries::Frame::FindFrameWithRelations
  include Query

  def initialize(frame_id:, private: true, user: nil)
    @frame_id = frame_id
    @private = private
    @user = user
  end

  def execute
    private_present = @private.present?
    scope = Frame.eager_load(:user, comments: :user)
    if @user.blank?
      if private_present
        scope.find_by!(id: @frame_id)
      else
        scope.find_by!(id: @frame_id, private: @private)
      end
    elsif private_present
      user_id = @user.id
      scope.eager_load(:user, comments: :user)
           .merge(
             Frame.where(user_id:).or(
              Frame.where(private: false).where.not(user_id:)
             )
           ).find_by!(id: @frame_id)
    end
  end
end
