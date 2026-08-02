# frozen_string_literal: true

# Api::Renderable module
module Api::Renderable
  extend ActiveSupport::Concern

  protected

  def render_resource(resource, status: :ok)
    render json: resource, status:
  end
end
