# frozen_string_literal: true

# Vesper::Stream::Renderable module
module Vesper::Stream::Renderable
  extend ActiveSupport::Concern
  include Vesper::Stream::Error::Renderable

  protected

  def render_stream(status: :ok)
    render layout: false, content_type: "text/vnd.turbo-stream.html", status:
  end
end
