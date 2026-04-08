# frozen_string_literal: true

Rails.application.config.i18n do |i18n|
  i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}").to_s]

  i18n.available_locales = [ :en, :ja ]
  i18n.enforce_available_locales = false
  i18n.default_locale = :en
  i18n.fallbacks = true
end

# I18n.available_locales = %i[en ja]
# I18n.enforce_available_locales = false
# I18n.default_locale = :en
# I18n.fallbacks = true
