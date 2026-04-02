# frozen_string_literal: true

# Queries::Frame::FindFrame class
class Queries::Frame::FindFrame
  include Query

  def initialize(frame_id:, private: true, user: nil, authenticated: false)
    @frame_id = frame_id
    @private = private
    @user = user
    @authenticated = authenticated
  end

  def execute
    private_present = @private.present?
    if @user.blank?
      if private_present
        Frame.find_by!(id: @frame_id)
      else
        Frame.find_by!(id: @frame_id, private: @private)
      end
    elsif private_present
      user_id = @user.id
      if @authenticated
        Frame.find_by!(id: @frame_id, user_id:)
      else
        Frame.merge(
          Frame.where(user_id:).or(
            Frame.where(private: false).where.not(user_id:)
          )
        ).find_by!(id: @frame_id)
      end
    end
  end
end
