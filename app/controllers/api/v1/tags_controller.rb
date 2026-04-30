# frozen_string_literal: true

# tag api controller
class Api::V1::TagsController < Api::V1::ApiController
  include Account::Authentication::Skip
  include Tags::Variables

  def search
    render_tags(tags:)
  end

  private

  def tags
    Queries::ApplicationTag::ListTagNames.run(name:).pluck(:name)
  end

  def render_tags(tags:)
    render_resource(Oj.dump({ tags: }))
  end
end
