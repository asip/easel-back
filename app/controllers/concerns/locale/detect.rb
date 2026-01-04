# frozen_string_literal: true

# locale
module Locale
  # Detect module
  module Detect
    extend ActiveSupport::Concern

    included do
      before_action :switch_locale
    end

    protected

    def switch_locale
      # logger.debug I18n.locale
      requested_locale_code = I18n.locale.to_s&.split(/-/)&.first
      effective_locale_code = I18n.available_locales.include?(requested_locale_code.to_sym) ? requested_locale_code : "en"
      # logger.debug "* Locale set to '#{effective_locale_code}'"
      I18n.locale = effective_locale_code.to_sym
    end
  end
end
