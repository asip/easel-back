# frozen_string_literal: true

# Api::ResourceRenderable module
module Api::ResourceRenderable
  extend ActiveSupport::Concern

  protected

  def render_account(account:)
    render_resource AccountResource.new(account).serialize
  end

  def render_user(user:)
    render_resource UserResource.new(user).serialize
  end

  def render_frame(frame:)
    render_resource Frame::DetailResource.new(frame).serialize
  end

  def render_frames(frames:, pagination:)
    render_resource Oj.load(Frame::List::ItemResource.new(frames).serialize(root_key: :frames, meta: pagination))
  end

  def render_comment(comment:)
    render_resource CommentResource.new(comment).serialize
  end

  def render_comments(comments:)
    render_resource CommentResource.new(comments).serialize(root_key: :comments)
  end
end
