# frozen_string_literal: true

# Api Controller
class Api::V1::ApiController < ActionController::Base
  include Api::ErrorRenderable
  include Locale::Detect
  include NPlusOne::Query::Detection unless Rails.env.production?
  include Account::Authentication

  # protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token
end
