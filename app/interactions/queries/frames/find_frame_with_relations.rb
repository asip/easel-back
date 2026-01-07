# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # FindFrameWithRelations class
    class FindFrameWithRelations
      include Query

      def initialize(frame_id:, private: nil, user: nil)
        @frame_id = frame_id
        @private = private
        @user = user
      end

      def execute
        private_nil = @private.nil?
        scope = Frame.eager_load(:user, comments: :user)
        if @user.blank?
          if private_nil
            scope.find_by!(id: @frame_id)
          else
            scope.find_by!(id: @frame_id, private: @private)
          end
        elsif private_nil
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
