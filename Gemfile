# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.7.2'

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft', '~> 0.7.0'

# gem 'dartsass-rails'

# Use mysql as the database for Active Record
# gem 'mysql2', '~> 0.5.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5.3'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.6.2'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'cssbundling-rails'
gem 'jsbundling-rails'

# view component
gem 'view_component'

# Shrine
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
gem 'kaminari', '~> 1.2.2'

# tags
# gem "acts-as-taggable-on", github: "mbleigh/acts-as-taggable-on"
gem 'acts-as-taggable-on', '~> 9.0.1'

# json
gem 'jsonapi-serializer'

# cors
gem 'rack-cors'

# soft delete
# gem 'discard', '~> 1.2'

# management console
gem 'rails_admin', '~> 3.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  # Ruby style guide, linter, and formatter
  gem 'factory_bot_rails'
  gem 'rspec-rails'
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

  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  # Shopify/erb-lint
  gem 'erb_lint', require: false
  gem 'ruby-lsp', require: false

  gem 'dockerfile-rails', '~>1.5.2'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
