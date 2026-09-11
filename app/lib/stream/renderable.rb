# frozen_string_literal: true

# Stream::Renderable module
module Stream::Renderable
  extend ActiveSupport::Concern
  include Stream::Error::Renderable

  protected

  def render_stream(status: :ok)
    render layout: false, content_type: "text/vnd.turbo-stream.html", status:
  end
end
