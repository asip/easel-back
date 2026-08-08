# frozen_string_literal: true

# Api::ErrorRenderable module
module Api::ErrorRenderable
  extend ActiveSupport::Concern

  included do
    # Standard Error
    rescue_from StandardError, with: ->(exception) { request.format.json? ? on_internal_server_error(exception) : raise(exception) }

    # ActiveRecord Error
    rescue_from ActiveRecord::RecordNotFound, with: ->(exception) { request.format.json? ? on_not_found(exception) : raise(exception) }
    rescue_from ActiveRecord::RecordNotUnique, with: ->(exception) { request.format.json? ? on_conflict(exception) : raise(exception) }
    rescue_from ActiveRecord::RecordInvalid, with: ->(exception) { request.format.json? ? on_unprocessable_content(exception) : raise(exception) }

    # UnauthorizedError
    # rescue_from UnauthorizedError, with: ->(exception) { request.format.json? ? on_unauthorized(exception) : raise(exception) }
  end

  # Custom error class for unauthorized access (未認証アクセス用のカスタムエラークラス)
  # class UnauthorizedError < StandardError
  #  def initialize(message = "Authentication information is invalid.")
  #    super(message)
  #  end
  # end

  protected

  def render_errors(resource:)
    render_resource ErrorMessagesResource.new(ErrorMessages.new(errors: resource.error_map)).serialize,
                                         status: :unprocessable_content
  end

  private

  # Common helper methods for rendering error response (エラーレスポンスをレンダリングする共通のヘルパーメソッド

  # HTTP Status 400 Bad Request
  def on_bad_request(exception = nil)
    render_error(:bad_request, "Bad Request", exception)
  end

  # HTTP Status 401 Unauthorized
  # def on_unauthorized(exception = nil)
  #   render_error(:unauthorized, "Unauthorized", exception)
  # end

  # HTTP Status 404 Not Found
  def on_not_found(exception = nil)
    render_error(:not_found, "Not Found", exception)
  end

  # HTTP Status 409 Conflict
  def on_conflict(exception = nil)
    render_error(:conflict, "Conflict", exception)
  end

  # HTTP Status 422 Unprocessable Content
  def on_unprocessable_content(exception = nil)
    render_error(:unprocessable_content, "Unprocessable Content", exception)
  end

  # HTTP Status 500 Internal Server Error
  def on_internal_server_error(exception = nil)
    logger.error exception.full_message
    # logger.error exception.backtrace.join("\n") # backtrace

    render_error(:internal_server_error, "Internal Server Error", exception)
  end

  def render_error(code, title, exception)
    code = Rack::Utils.status_code(code)

    error = {
      title:,
      detail: exception&.message
    }

    if code == Rack::Utils.status_code(:not_found)
      error[:source] = exception.model
    end

    # puts error

    render_resource ErrorMapResource.new(ErrorMap.new(error)).serialize,
                    status: code
  end
end
