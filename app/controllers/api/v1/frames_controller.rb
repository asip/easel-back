# frozen_string_literal: true

# Api
module Api
  # V1
  module V1
    # Frames Controller
    class FramesController < Api::V1::ApiController
      include Pagination

      skip_before_action :authenticate, only: %i[index show]
      before_action :set_query, only: [:index]
      before_action :set_frame, only: %i[show create update destroy]

      def index
        frames = Frame.eager_load(:comments).search_by(word: @word).order(created_at: 'desc')
        frames = frames.page(@page)
        pagination = resources_with_pagination(frames)

        render json: FrameSerializer.new(frames, index_options).serializable_hash.merge(pagination)
      end

      def show
        frame = Frame.eager_load(:comments).find_by(id: params[:id])

        render json: FrameSerializer.new(frame, index_options).serializable_hash
      end

      def create
        @frame.user_id = current_user.id
        @frame.file_derivatives! if @frame.file.present?
        if @frame.save
          render json: FrameSerializer.new(@frame, index_options).serializable_hash
        else
          render json: { errors: @frame.errors.messages }.to_json
        end
      end

      # rubocop:disable Metrics/AbcSize
      def update
        @frame.user_id = current_user.id
        @frame.attributes = frame_params
        @frame.file_derivatives! if @frame.file.present?
        if @frame.save
          render json: FrameSerializer.new(@frame, index_options).serializable_hash
        else
          render json: { errors: @frame.errors.messages }.to_json
        end
      end

      # rubocop:enable Metrics/AbcSize

      def destroy
        @frame.destroy
        render json: FrameSerializer.new(@frame, index_options).serializable_hash
      end

      private

      def index_options
        { include: [:comments] }
      end

      def set_query
        @word = permitted_params[:q]
        @page = permitted_params[:page]
      end

      def permitted_params
        params.permit(
          :q,
          :page
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
