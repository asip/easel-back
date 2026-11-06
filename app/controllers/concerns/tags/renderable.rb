# frozen_string_literal: true

# Tags::Renderble module
module Tags::Renderable
  extend ActiveSupport::Concern

  protected

  def render_tags(tags)
    render_resource TagListResource.new(TagList.new(tags:)).serialize
  end
end
