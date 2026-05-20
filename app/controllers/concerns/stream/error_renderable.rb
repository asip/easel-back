# frozen_string_literal: true

# Stream::ErrorRenderable module
module Stream::ErrorRenderable
  extend ActiveSupport::Concern

  protected

  def render_error_stream
    render_stream status: :unprocessable_content
  end
end
