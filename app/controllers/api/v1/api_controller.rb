# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Api Controller
    class ApiController < ActionController::Base
      include Api::ErrorRenderable
      include Locale::AutoDetect
      include NPlusOne::Query::Detection unless Rails.env.production?
      include Account::Authentication

      # protect_from_forgery with: :exception

      skip_before_action :verify_authenticity_token
    end
  end
end
