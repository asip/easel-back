# frozen_string_literal: true

Rails.application.config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}").to_s]

Rails.application.config.i18n.available_locales = [ :en, :ja ]
Rails.application.config.i18n.enforce_available_locales = false
Rails.application.config.i18n.default_locale = :en
Rails.application.config.i18n.fallbacks = true

# I18n.available_locales = %i[en ja]
# I18n.enforce_available_locales = false
# I18n.default_locale = :en
# I18n.fallbacks = true
