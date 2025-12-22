# frozen_string_literal: true

# api
module Api
  # Error Renderable
  module ErrorRenderable
    extend ActiveSupport::Concern

    included do
      # Standard Error
      rescue_from StandardError, with: ->(e) { request.format.json? ? render500(e) : raise(e) }

      # ActiveRecord Error
      rescue_from ActiveRecord::RecordNotFound, with: ->(e) { request.format.json? ? render404(e) : raise(e) }
      rescue_from ActiveRecord::RecordNotUnique, with: ->(e) { request.format.json? ? render409(e) : raise(e) }
      rescue_from ActiveRecord::RecordInvalid, with: ->(e) { request.format.json? ? render422(e) : raise(e) }

      # UnauthorizedError
      # rescue_from UnauthorizedError, with: ->(e) { request.format.json? ? render401(e) : raise(e) }
    end

    # Custom error class for unauthorized access (未認証アクセス用のカスタムエラークラス)
    # class UnauthorizedError < StandardError
    #  def initialize(message = "Authentication information is invalid.")
    #    super(message)
    #  end
    # end

    protected

    # Common helper methods for rendering error response (エラーレスポンスをレンダリングする共通のヘルパーメソッド

    # HTTP Status 400 Bad Request
    def render400(exception = nil, *messages)
      render_error(400, "Bad Request", exception, exception&.message, *messages)
    end

    # HTTP Status 401 Unauthorized
    # def render401(exception = nil, *messages)
    #   render_error(401, "Unauthorized", exception, exception&.message, *messages)
    # end

    # HTTP Status 404 Not Found
    def render404(exception = nil, *messages)
      render_error(404, "Not Found", exception, exception&.message, *messages)
    end

    # HTTP Status 409 Conflict
    def render409(exception = nil, *messages)
      render_error(409, "Conflict", exception, exception&.message, *messages)
    end

    # HTTP Status 422 Unprocessable Entity
    def render422(exception = nil, *messages)
      render_error(422, "Unprocessable Entity", exception, exception&.message, *messages)
    end

    # HTTP Status 500 Internal Server Error
    def render500(exception = nil, *messages)
      logger.error exception.full_message
      # logger.error exception.backtrace.join("\n") # backtrace

      render_error(500, "Internal Server Error", exception, exception&.message, *messages)
    end

    def render_error(code, title, exception, *error_messages)
      response = {
        title:,
        errors: error_messages.compact.uniq
      }

      if code == 404
        response[:source] = exception.model
      end

      render json: response, status: code
    end
  end
end
