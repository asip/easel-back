# frozen_string_literal: true

# Api
module Api
  # V1
  module V1
    # Api Controller
    # rubocop:disable Rails/ApplicationController
    class ApiController < ActionController::Base
      include Api::ExceptionHandler
      include Locale::AutoDetect

      protect_from_forgery with: :exception

      before_action :switch_locale
      before_action :authenticate
      skip_before_action :verify_authenticity_token

      protected

      def authenticate
        login_from_jwt
        @current_user = nil unless @current_user && @current_user.token == token
        @current_user.present?
        raise(Api::ExceptionHandler::UnauthorizedError) if @current_user.nil?
      end

      def logged_in?
        current_user.present?
      end

      # def set_csrf_token
      #   response.set_header('X-CSRF-Token', form_authenticity_token)
      # end
    end
  end
  # rubocop:enable Rails/ApplicationController
end
