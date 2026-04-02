# frozen_string_literal: true

# tag api controller
class Api::V1::TagsController < Api::V1::ApiController
  include Account::Authentication::Skip

  def search
    render_tags(tags:)
  end

  private

  def tags
    Queries::ApplicationTag::ListTagNames.run(name:).pluck(:name)
  end

  def route_params
    @route_params ||= params.permit(:q).to_h
  end

  def name
    route_params[:q]
  end

  def render_tags(tags:)
    render json: { tags: }
  end
end
