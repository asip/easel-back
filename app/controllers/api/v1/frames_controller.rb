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
      before_action :set_case

      def index
        pagination, frames = list_query(word: query_params[:q], page: query_params[:page])

        render json: ListItem::FrameSerializer.new(frames, index_options).serializable_hash.merge(pagination)
      end

      def show
        frame = @case.find_query_with_relations(frame_id: params[:id])

        render json: Detail::FrameSerializer.new(frame, detail_options).serializable_hash
      end

      def comments
        comments = @case.comments_query_with_user(frame_id: query_params[:frame_id])

        # options = {}
        # options[:include] = [:user]

        render json: CommentSerializer.new(comments).serializable_hash
      end

      def create
        success, frame = @case.create_frame(user: current_user, form_params:)

        if success
          render json: Detail::FrameSerializer.new(frame, detail_options).serializable_hash
        else
          render json: { errors: frame.errors.messages }.to_json
        end
      end

      def update
        success, frame = @case.update_frame(user: current_user, frame_id: params[:id], form_params:)

        if success
          render json: Detail::FrameSerializer.new(frame, detail_options).serializable_hash
        else
          render json: { errors: frame.errors.messages }.to_json
        end
      end

      def destroy
        frame = @case.delete_frame(user: current_user, frame_id: params[:id])
        render json: Detail::FrameSerializer.new(frame, detail_options).serializable_hash
      end

      private

      def set_case
        @case = FramesCase.new
      end

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
