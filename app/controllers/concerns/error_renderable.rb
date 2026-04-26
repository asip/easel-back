# frozen_string_literal: true

# ErrorRenderable module
module ErrorRenderable
  extend ActiveSupport::Concern

  protected

  def render_error_stream
    render layout: false, content_type: "text/vnd.turbo-stream.html", status: :unprocessable_content
  end
end
