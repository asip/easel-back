# frozen_string_literal: true

# Locale::Detect module
module Locale::Detect
  extend ActiveSupport::Concern

  included do
    before_action :switch_locale
  end

  protected

  def switch_locale
    I18n.locale = locale.to_sym
    # logger.debug "* Locale set to '#{locale}'"
  end

  private

  def browser_locale
    request.env["HTTP_ACCEPT_LANGUAGE"]&.scan(/^(?:[a-z]{2}-[A-Z]{2}|[a-z]{2}-[0-9]+|[a-z]{2})/)&.first || ""
  end

  def browser_short_locale
    browser_locale&.split("-")[0] || ""
  end

  def locale
    available_locales = I18n.available_locales
    available_locales.include?(browser_locale.to_sym) || available_locales.include?(browser_short_locale.to_sym) ?
      browser_locale : I18n.default_locale
  end
end
