# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # FindFrameWithRelations
    class FindFrameWithRelations
      include Query

      def initialize(frame_id:, private: nil, user: nil)
        @frame_id = frame_id
        @private = private
        @user = user
      end

      def execute
        scope = Frame.eager_load(:user, comments: :user)
        if @user.blank?
          if  @private.present?
            scope.find_by!(id: @frame_id, private: @private)
          else
            scope.find_by!(id: @frame_id)
          end
        elsif @private.blank?
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
  end
end
