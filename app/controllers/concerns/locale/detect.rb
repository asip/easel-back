# frozen_string_literal: true

# Locale::Detect module
module Locale::Detect
  extend ActiveSupport::Concern

  included do
    before_action :switch_locale
  end

  protected

  def switch_locale
    browser_locale_code = request.env["HTTP_ACCEPT_LANGUAGE"]&.scan(/^[a-z]{2}/)&.first || ""
    locale_code = I18n.available_locales.include?(browser_locale_code.to_sym) ? browser_locale_code : I18n.default_locale
    # logger.debug "* Locale set to '#{locale_code}'"
    I18n.locale = locale_code.to_sym
  end
end
