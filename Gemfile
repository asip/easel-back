# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.2'

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft', '~> 0.8.0'

# gem 'dartsass-rails'

# Use mysql as the database for Active Record
# gem 'mysql2', '~> 0.5.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5.3'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.4.0'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'cssbundling-rails'
gem 'jsbundling-rails'

# view component
gem 'view_component'

# Shrine
gem 'aws-sdk-s3', '~> 1.14'
gem 'image_processing', '~> 1.8'
gem 'marcel', '~> 1.0'
gem 'shrine', '~> 3.0'

# i18n
gem 'rails-i18n', '~> 7.0.0'

# error page handling
gem 'rambulance'

# authentication
gem 'sorcery'
gem 'sorcery-jwt'

gem 'googleauth'

# settings
gem 'config'

# paging
gem 'pagy', '~> 6.1.0'

# tags
# gem "acts-as-taggable-on", github: "mbleigh/acts-as-taggable-on"
gem 'acts-as-taggable-on', '~> 10.0.0'

# json
gem 'jsonapi-serializer'

# cors
gem 'rack-cors'

# soft delete
gem 'discard', '~> 1.2'

# management console
gem 'rails_admin', '~> 3.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'debug', platforms: %i[mri windows]
  gem 'pg_query'
  gem 'prosopite'
end

group :development do
  gem 'brakeman'
  gem 'bullet'

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  gem 'annotate'
  gem 'rails-erd'

  # Ruby style guide, linter, and formatter
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  # gem 'rubocop-sensei', require: false
  # Shopify/erb-lint
  gem 'erb_lint', require: false
  gem 'ruby-lsp', require: false

  gem 'dockerfile-rails', '~>1.5.10'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  gem 'factory_bot_rails'
  gem 'faker'
  gem 'jsonapi-rspec'
  gem 'rspec-rails'
end
