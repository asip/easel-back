# frozen_string_literal: true

# FollowerRelationships::Variables module
module FollowerRelationships::Variables
  extend ActiveSupport::Concern

  protected

  def route_params
    @route_params ||= params.permit(:user_id).to_h
  end

  def user_id
    route_params[:user_id]
  end
end
