# frozen_string_literal: true

# Frames::Locale::Detect::Skip module
module Frames::Locale::Detect::Skip
  extend ActiveSupport::Concern

  included do
    skip_before_action :switch_locale, only: [ :comments ]
  end
end
