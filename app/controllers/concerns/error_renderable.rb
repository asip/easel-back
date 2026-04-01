# frozen_string_literal: true

# ErrorRenderable module
module ErrorRenderable
  extend ActiveSupport::Concern

  protected

  def render_error_stream
    render layout: false, content_type: "text/vnd.turbo-stream.html", status: :unprocessable_content
  end

  def render_login_errors(resource:)
    flashes[:alert] = resource.full_error_messages_on_login unless resource.errors.empty?
    render_error_stream
  end
end
