# frozen_string_literal: true

# Stream::Error::Renderable module
module Stream::Error::Renderable
  extend ActiveSupport::Concern

  protected

  def render_error_stream
    render_stream status: :unprocessable_content
  end
end
