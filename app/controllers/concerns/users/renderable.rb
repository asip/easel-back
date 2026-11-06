# frozen_string_literal: true

# Users::Renderble module
module Users::Renderable
  extend ActiveSupport::Concern

  protected

  def render_user(user)
    render_resource UserResource.new(user).serialize
  end
end
