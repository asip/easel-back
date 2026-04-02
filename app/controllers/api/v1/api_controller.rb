# frozen_string_literal: true

# Api Controller
class Api::V1::ApiController < ActionController::API
  include Api::ErrorRenderable
  include Api::ResourceRenderable
  include Locale::Detect
  include NPlusOne::Query::Detection unless Rails.env.production?
  include Account::Authentication
end
