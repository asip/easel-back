# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Api Controller
    class ApiController < ActionController::API
      include AbstractController::Helpers
      include Api::ExceptionHandler
      include Locale::AutoDetect
      include NPlusOne::Query::Detection unless Rails.env.production?

      # protect_from_forgery with: :exception

      before_action :authenticate
      # skip_before_action :verify_authenticity_token

      protected

      def authenticate
        login_from_jwt
        @current_user = nil unless @current_user && @current_user.token == token

        raise(Api::ExceptionHandler::UnauthorizedError) if @current_user.nil?
      end

      # def set_csrf_token
      #   response.set_header('X-CSRF-Token', form_authenticity_token)
      # end
    end
  end
end
