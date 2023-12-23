# frozen_string_literal: true

# locale
module Locale
  # AutoDetect module
  module AutoDetect
    extend ActiveSupport::Concern

    included do
      before_action :switch_locale
    end

    protected

    def switch_locale
      # logger.debug I18n.locale
      locale = I18n.locale.to_s&.split(/-/)&.first
      locale = I18n.available_locales.include?(locale.to_sym) ? locale : 'en'
      # logger.debug "* Locale set to '#{locale}'"
      I18n.locale = locale.to_sym
    end
  end
end
