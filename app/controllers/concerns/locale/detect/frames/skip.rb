# frozen_string_literal: true

# locale/detect/frames/Skip module
module Locale::Detect::Frames::Skip
  extend ActiveSupport::Concern

  included do
    skip_before_action :switch_locale, only: [ :comments ]
  end
end
