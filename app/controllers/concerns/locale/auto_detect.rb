# frozen_string_literal: true

# locale
module Locale
  # AutoDetect module
  module AutoDetect
    extend ActiveSupport::Concern
    def switch_locale
      # logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
      locale = extract_locale_from_accept_language
      # logger.debug "* Locale set to '#{locale}'"
      I18n.config.locale = locale.to_sym
    end

    protected

    def extract_locale_from_accept_language
      # puts request.env['HTTP_ACCEPT_LANGUAGE']
      locale = request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
      locale = (locale.presence || '')
      # puts locale
      I18n.config.available_locales.include?(locale.to_sym) ? locale : 'en'
    end
  end
end
