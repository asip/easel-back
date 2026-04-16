# frozen_string_literal: true

# HttpHeaders module
module HttpHeaders
  extend ActiveSupport::Concern

  protected

  def time_zone
    @time_zone ||= request.headers["Time-Zone"]
    # puts time_zone
  end
end
