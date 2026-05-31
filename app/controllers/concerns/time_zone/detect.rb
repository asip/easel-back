# frozen_string_literal: true

# TimeZone::Detect module
module TimeZone::Detect
  extend ActiveSupport::Concern

  included do
    before_action :set_time_zone
  end

  protected

  def set_time_zone
    # puts request.headers["Time-Zone"]
    @time_zone = request.headers["Time-Zone"]
  end

  def time_zone
    @time_zone
  end
end
