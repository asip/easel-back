# frozen_string_literal: true

# Api::ResourceRenderable module
module Api::ResourceRenderable
  extend ActiveSupport::Concern

  protected

  def render_account(account:)
    render json: AccountResource.new(account).serializable_hash, status: :ok
  end

  def render_user(user:)
    render json: UserResource.new(user).serializable_hash
  end

  def render_frame(frame:)
    render json: Detail::FrameResource.new(frame).serializable_hash
  end

  def render_frames(frames:, pagination:)
    render json: Oj.load(ListItem::FrameResource.new(frames).serialize).merge(pagination)
  end

  def render_comment(comment:)
    # logger.debug CommentResource.new(comment).serialize
    render json: CommentResource.new(comment).serializable_hash
  end

  def render_comments(comments:)
    # logger.debug CommentResource.new(comments).serialize
    render json: CommentResource.new(comments).serialize
  end

  def render_errors(resource:)
    render json: Oj.dump({ errors: resource.errors.to_hash(false) }), status: :unprocessable_content
  end
end
