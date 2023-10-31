# frozen_string_literal: true

# Api
module Api
  # V1
  module V1
    # Frames Controller
    class FramesController < Api::V1::ApiController
      include Pagy::Backend
      include Pagination

      skip_before_action :switch_locale, only: [:comments]
      skip_before_action :authenticate, only: %i[index show comments]
      before_action :set_query, only: [:index]
      before_action :set_frame, only: %i[show create update destroy]

      def index
        frames = Frame.search_by(word: @word).order(created_at: 'desc')
        pagy, frames = pagy(frames, { page: @page })
        frame_ids = frames.pluck(:id)
        pagination = resources_with_pagination(pagy)
        frames = Frame.where(id: frame_ids).order(created_at: 'desc')

        render json: ListItem::FrameSerializer.new(frames, index_options).serializable_hash.merge(pagination)
      end

      def show
        frame = Frame.eager_load(:user, comments: :user).find_by!(id: params[:id])

        render json: Detail::FrameSerializer.new(frame, detail_options).serializable_hash
      end

      def comments
        comments = Frame.eager_load(comments: :user).find_by!(id: query_params[:frame_id]).comments
                        .order('comments.created_at': 'asc')

        # options = {}
        # options[:include] = [:user]

        render json: CommentSerializer.new(comments).serializable_hash
      end

      def create
        @frame.user_id = current_user.id
        if @frame.save
          @frame.assign_derivatives
          render json: Detail::FrameSerializer.new(@frame, detail_options).serializable_hash
        else
          render json: { errors: @frame.errors.messages }.to_json
        end
      end

      def update
        @frame.user_id = current_user.id
        @frame.attributes = frame_params
        if @frame.save
          @frame.assign_derivatives
          render json: Detail::FrameSerializer.new(@frame, detail_options).serializable_hash
        else
          render json: { errors: @frame.errors.messages }.to_json
        end
      end

      def destroy
        @frame.destroy
        render json: Detail::FrameSerializer.new(@frame, detail_options).serializable_hash
      end

      private

      def index_options
        {}
      end

      def detail_options
        { include: [:comments] }
      end

      def set_query
        @word = query_params[:q]
        @page = query_params[:page]
      end

      def query_params
        params.permit(
          :q,
          :page,
          :frame_id
        )
      end

      def set_frame
        @frame = case action_name
                 when 'show'
                   Frame.find(params[:id])
                 when 'new'
                   Frame.new
                 when 'create'
                   Frame.new(frame_params)
                 else
                   Frame.find_by!(id: params[:id], user_id: current_user.id)
                 end
      end

      def frame_params
        params.require(:frame).permit(
          :name,
          :tag_list,
          :comment,
          :file,
          :shooted_at
        )
      end
    end
  end
end
