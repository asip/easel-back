# frozen_string_literal: true

# Frames::Authentication::Skip module
module Frames::Authentication::Skip
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!, only: %i[index show comments]
  end
end
