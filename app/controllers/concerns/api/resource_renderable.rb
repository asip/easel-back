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
    render json: Frame::DetailResource.new(frame).serializable_hash
  end

  def render_frames(frames:, pagination:)
    render json: Oj.load(Frame::List::ItemResource.new(frames).serialize).merge(pagination)
  end

  def render_comment(comment:)
    render json: CommentResource.new(comment).serializable_hash
  end

  def render_comments(comments:)
    render json: CommentResource.new(comments).serialize
  end
end
