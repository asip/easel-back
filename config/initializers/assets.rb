# frozen_string_literal: true

Rails.application.config.assets.paths << Rails.root.join('app/assets/builds')
# Rails.application.config.assets.paths << Rails.root.join('node_modules')
# Rails.application.config.assets.paths << Rails.root.join('node_modules/bootstrap-icons/font')
# Rails.application.config.assets.paths << Rails.root.join('node_modules/@fortawesome/fontawesome-free/webfonts')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( manager.js manager.css )
