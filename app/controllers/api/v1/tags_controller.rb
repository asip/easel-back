# frozen_string_literal: true

# tag api controller
class Api::V1::TagsController < Api::V1::AppController
  include Tags::Variables
  include Tags::Renderable

  def search
    render_tags(tags)
  end

  private

  def tags
    Queries::ApplicationTag::ListTagNames.run(name:).pluck(:name)
  end
end
