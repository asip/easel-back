# frozen_string_literal: true

# FollowerRelationships::Renderable module
module FollowerRelationships::Renderable
  extend ActiveSupport::Concern

  protected

  def render_following(following)
    render_resource FollowingResource.new(Following.new(following:)).serialize
  end
end
