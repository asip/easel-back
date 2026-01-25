# frozen_string_literal: true

# Api::ErrorRenderable module
module Api::ErrorRenderable
  extend ActiveSupport::Concern

  included do
    # Standard Error
    rescue_from StandardError, with: ->(exception) { request.format.json? ? internal_server_error(exception) : raise(exception) }

    # ActiveRecord Error
    rescue_from ActiveRecord::RecordNotFound, with: ->(exception) { request.format.json? ? not_found(exception) : raise(exception) }
    rescue_from ActiveRecord::RecordNotUnique, with: ->(exception) { request.format.json? ? conflict(exception) : raise(exception) }
    rescue_from ActiveRecord::RecordInvalid, with: ->(exception) { request.format.json? ? unprocessable_content(exception) : raise(exception) }

    # UnauthorizedError
    # rescue_from UnauthorizedError, with: ->(exception) { request.format.json? ? unauthorized(exception) : raise(exception) }
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
  def bad_request(exception = nil)
    render_error(400, "Bad Request", exception)
  end

  # HTTP Status 401 Unauthorized
  # def unauthorized(exception = nil)
  #   render_error(401, "Unauthorized", exception)
  # end

  # HTTP Status 404 Not Found
  def not_found(exception = nil)
    render_error(404, "Not Found", exception)
  end

  # HTTP Status 409 Conflict
  def conflict(exception = nil)
    render_error(409, "Conflict", exception)
  end

  # HTTP Status 422 Unprocessable Content
  def unprocessable_content(exception = nil)
    render_error(422, "Unprocessable Content", exception)
  end

  # HTTP Status 500 Internal Server Error
  def internal_server_error(exception = nil)
    logger.error exception.full_message
    # logger.error exception.backtrace.join("\n") # backtrace

    render_error(500, "Internal Server Error", exception)
  end

  def render_error(code, title, exception)
    response = {
      title:,
      errors: exception&.message ? [ exception&.message ] : []
    }

    if code == 404
      response[:source] = exception.model
    end

    render json: response, status: code
  end
end
