# frozen_string_literal: true

# Vesper::Api::Renderable module
module Vesper::Api::Renderable
  extend ActiveSupport::Concern
  include Vesper::Api::Error::Renderable

  protected

  def render_resource(resource, status: :ok)
    render json: resource, status:
  end
end
