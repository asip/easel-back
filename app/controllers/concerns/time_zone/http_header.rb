# frozen_string_literal: true

# TimeZone::HttpHeader module
module TimeZone::HttpHeader
  extend ActiveSupport::Concern

  protected

  def time_zone
    @time_zone ||= request.headers["Time-Zone"]
    # puts time_zone
  end
end
