# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.2"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft", "~> 1.3.1"

# Use mysql as the database for Active Record
# gem 'mysql2', '~> 0.5.6'
# Use postgresql as the database for Active Record
gem "pg", "~> 1.6.3"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 7.2.0"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "~> 2.0.23"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "~> 1.3.4"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.14.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.22.0", require: false

# vite integration
gem "vite_rails", "3.0.20"

# view component
gem "view_component", "~> 4.2.0"

# Shrine
gem "aws-sdk-s3", "~> 1.213.0"
gem "image_processing", "~> 1.14.0"
gem "marcel", "~> 1.1.0"
gem "shrine", "~> 3.6.0"

# gem "anyway_config", "2.8.0"
# image (processing) proxy
gem "imgproxy", "~> 3.0.0", require: false

# i18n
gem "rails-i18n", "~> 8.1.0"

# error page handling
gem "rambulance", "~> 3.3.0"

# authentication
gem "devise", "5.0.0"
gem "devise-jwt", "0.13.0"
gem "devise-i18n", "1.16.0"
gem "omniauth-google-oauth2", "1.2.1"

gem "googleauth", "~> 1.16.1"

# settings
gem "config", "~> 5.6.1"

# paging
gem "pagy", "~> 43.2.9"

# tags
gem "no_fly_list", "0.7.3"

# json
gem "oj", "3.16.15"
gem "alba", "3.10.0"

# Rack::Locale
gem "rack-contrib", "2.5.0"

# cors
gem "rack-cors", "~> 3.0.0"

# soft delete
gem "discard", "~> 1.4.0"

# redis
gem "redis-actionpack", "~> 5.5.0"

# management console
gem "rails_admin", "3.3.0"

gem "mutex_m", "~> 0.3.0"

gem "cgi", "~> 0.5.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "debug", "~> 1.11.0", platforms: %i[mri windows], require: "debug/prelude"
  gem "pg_query", "~> 6.2.2"
  gem "prosopite", "~> 2.1.2"
end

group :development do
  gem "bullet", "~> 8.1.0"

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", "~> 4.2.1"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  gem "annotaterb", "~> 4.21.0"
  gem "rails-erd", "~> 1.7.2"

  gem "rubocop", "~> 1.84.1", require: false
  gem "rubocop-rails", "~> 2.34.3", require: false
  # Ruby style guide, linter, and formatter
  gem "rubocop-rails-omakase", "~> 1.1.0", require: false
  # Shopify/erb-lint
  gem "erb_lint", "~> 0.9.0", require: false
  gem "ruby-lsp", "~> 0.26.5", require: false

  gem "brakeman", "~> 8.0.2", require: false
  gem "reek", "~> 6.5.0", require: false
  gem "traceroute", "~> 0.8.1"

  gem "dockerfile-rails", "~>1.7.10"
end

group :test do
  gem "observer", "~> 0.1.2"

  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  # gem "capybara", "~> 3.40.0"
  # gem "selenium-webdriver", "~> 4.35.0"

  gem "factory_bot_rails", "~> 6.5.1"
  gem "faker", "~> 3.6.0"
  gem "rspec-rails", "~> 8.0.2"
  # Use to generate OpenAPI specs from RSpec request specs
  gem "rspec-openapi", "~> 0.24.0"
  gem "committee-rails", "~> 0.10.0"
  gem "test-prof", "~> 1.5.2"
end
