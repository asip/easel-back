# frozen_string_literal: true

# Frames::Locale::Detect::Skip module
module Frames::Locale::Detect::Skip
  extend ActiveSupport::Concern

  SKIP_ACTION_LIST_FOR_LOCALE = [ :comments ]

  included do
    skip_before_action :switch_locale, only: SKIP_ACTION_LIST_FOR_LOCALE
  end
end
