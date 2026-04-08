# frozen_string_literal: true

# Locale::Detect module
module Locale::Detect
  extend ActiveSupport::Concern

  included do
    before_action :switch_locale
  end

  protected

  def switch_locale
    # logger.debug I18n.locale
    browser_locale_code = I18n.locale.to_s&.split(/-/)&.first
    locale_code = I18n.available_locales.include?(browser_locale_code.to_sym) ? browser_locale_code : Rails.application.config.i18n.default_locale
    # logger.debug "* Locale set to '#{locale_code}'"
    I18n.locale = locale_code.to_sym
  end
end
