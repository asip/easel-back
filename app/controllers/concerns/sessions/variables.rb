# frozen_string_literal: true

# Sessions::Variables module
module Sessions::Variables
  extend ActiveSupport::Concern

  protected

  def route_params
    @route_params ||= params.permit(:page).to_h
  end

  def page
    route_params[:page]
  end
end
