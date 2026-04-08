# frozen_string_literal: true

# Frames::Variables module
module Frames::Variables
  extend ActiveSupport::Concern

  protected

  def route_params
    @route_params ||= params.permit(:id, :frame_id, :q, :page).to_h
  end

  def page
    route_params[:page]
  end

  def criteria
    route_params[:q]
  end

  def q_items
    JsonUtil.to_hash(criteria)
  end

  def form
    @form ||= FrameSearchForm.new(q_items)
  end

  def id
    route_params[:id]
  end

  def frame_id
    route_params[:frame_id]
  end

  def form_params
    @form_params ||= params.expect(
      frame: [ :name, :tag_list, :comment, :file, :creator_name, :shooted_at, :private ]
    ).to_h
  end
end
