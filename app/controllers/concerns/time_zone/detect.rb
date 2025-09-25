# frozen_string_literal: true

# time_zone
module TimeZone
  # Detect module
  module Detect
    extend ActiveSupport::Concern

    included do
      before_action :set_time_zone
    end

    protected

    def set_time_zone
      # puts cookies.to_h
      # puts cookies[:time_zone]
      @time_zone = request.headers["Time-Zone"]
      # puts @time_zone
    end
  end
end
