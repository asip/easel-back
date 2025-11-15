# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Frames Controller
    class FramesController < Api::V1::ApiController
      include Queries::Frames::Pagination

      skip_before_action :switch_locale, only: [ :comments ]
      skip_before_action :authenticate_user!, only: %i[index show comments]

      def index
        query = query_params[:q]
        page = query_params[:page]
        items = Json::Util.to_hash(query)
        form = FrameSearchForm.new(items)
        if form.valid?
          pagination, frames = list_frames(items: form.to_h, page:)

          render json: JSON.parse(ListItem::FrameResource.new(frames).serialize).merge(pagination)
        else
          render json: { errors: form.errors.to_hash(false) }.to_json, status: :unprocessable_entity
        end
      end

      def show
        frame = Queries::Frames::FindFrameWithRelations.run(frame_id: params[:id], private: false)

        render json: Detail::FrameResource.new(frame).serializable_hash
      end

      def comments
        comments = Queries::Frames::ListCommentsWithUser.run(frame_id: path_params[:frame_id])

        # options = {}
        # options[:include] = [:user]

        render json: CommentResource.new(comments).serialize
      end

      def create
        mutation = Mutations::Frames::CreateFrame.run(user: current_user, form_params:)
        frame = mutation.frame

        if mutation.success?
          render json: Detail::FrameResource.new(frame).serializable_hash
        else
          render json: { errors: frame.errors.to_hash(false) }.to_json, status: :unprocessable_entity
        end
      end

      def update
        mutation = Mutations::Frames::UpdateFrame.run(user: current_user, frame_id: params[:id], form_params:)
        frame = mutation.frame

        if mutation.success?
          render json: Detail::FrameResource.new(frame).serializable_hash
        else
          render json: { errors: frame.errors.to_hash(false) }.to_json, status: :unprocessable_entity
        end
      end

      def destroy
        mutation = Mutations::Frames::DeleteFrame.run(user: current_user, frame_id: params[:id])
        frame = mutation.frame
        render json: Detail::FrameResource.new(frame).serializable_hash
      end

      private

      def query_params
        params.permit(:q, :page).to_h
      end

      def path_params
        params.permit(:frame_id).to_h
      end

      def form_params
        params.expect(
          frame: [ :name, :tag_list, :comment, :file, :creator_name, :shooted_at ]
        ).to_h
      end
    end
  end
end
