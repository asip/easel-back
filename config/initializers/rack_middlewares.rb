# frozen_string_literal: true

Rails.application.config do |config|
  config.middleware.use ActionDispatch::Flash
  config.middleware.use Rack::Locale
end
