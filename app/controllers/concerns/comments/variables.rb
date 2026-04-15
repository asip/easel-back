# frozen_string_literal: true

# Comments::Variables module
module Comments::Variables
  extend ActiveSupport::Concern

  protected

  def route_params
    @route_params ||= params.permit(:id, :frame_id).to_h
  end

  def frame_id
    route_params[:frame_id]
  end

  def comment_id
    route_params[:id]
  end

  def form_params
    @form_params ||= params.expect(comment: [ :body ]).to_h
  end
end
