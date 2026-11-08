# frozen_string_literal: true

# Frames::Authentication::Skip module
module Frames::Authentication::Skip
  extend ActiveSupport::Concern

  SKIP_ACTION_LIST_FOR_AUTH = %i[index show comments]

  included do
    skip_before_action :authenticate_user!, only: SKIP_ACTION_LIST_FOR_AUTH
  end
end
