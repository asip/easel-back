# frozen_string_literal: true

# Comments::Renderble module
module Comments::Renderable
  extend ActiveSupport::Concern

  protected

  def render_comment(comment)
    render_resource CommentResource.new(comment).serialize
  end

  def render_comments(comments)
    render_resource CommentResource.new(comments).serialize(root_key: :comments)
  end
end
