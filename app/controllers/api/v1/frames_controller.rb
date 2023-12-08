# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Frames Controller
    class FramesController < Api::V1::ApiController
      include Frames::Query::PaginationQuery

      skip_before_action :switch_locale, only: [:comments]
      skip_before_action :authenticate, only: %i[index show comments]

      def index
        pagination, frames = list_query(word: query_params[:q], page: query_params[:page])

        render json: ListItem::FrameSerializer.new(frames, index_options).serializable_hash.merge(pagination)
      end

      def show
        frame = Queries::Frames::FindFrameWithRelations.run(frame_id: params[:id])

        render json: Detail::FrameSerializer.new(frame, detail_options).serializable_hash
      end

      def comments
        comments = Queries::Frames::ListCommentsWithUser.run(frame_id: query_params[:frame_id])

        # options = {}
        # options[:include] = [:user]

        render json: CommentSerializer.new(comments).serializable_hash
      end

      def create
        mutation = Mutations::Frames::CreateFrame.run(user: current_user, form_params:)
        frame = mutation.frame

        if mutation.success?
          render json: Detail::FrameSerializer.new(frame, detail_options).serializable_hash
        else
          render json: { errors: frame.errors.to_hash(true) }.to_json
        end
      end

      def update
        mutation = Mutations::Frames::UpdateFrame.run(user: current_user, frame_id: params[:id], form_params:)
        frame = mutation.frame

        if mutation.success?
          render json: Detail::FrameSerializer.new(frame, detail_options).serializable_hash
        else
          render json: { errors: frame.errors.to_hash(true) }.to_json
        end
      end

      def destroy
        mutation = Mutations::Frames::DeleteFrame.run(user: current_user, frame_id: params[:id])
        frame = mutation.frame
        render json: Detail::FrameSerializer.new(frame, detail_options).serializable_hash
      end

      private

      def index_options
        {}
      end

      def detail_options
        { include: [:comments] }
      end

      def query_params
        params.permit(
          :q, :page, :frame_id
        )
      end

      def form_params
        params.require(:frame).permit(
          :name, :tag_list, :comment, :file, :shooted_at
        )
      end
    end
  end
end
