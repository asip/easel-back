# frozen_string_literal: true

# api
module Api
  # Error Renderable
  module ErrorRenderable
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError, with: ->(e) { request.format.json? ? render500(e) : raise(e) }
      rescue_from ActiveRecord::RecordNotFound, with: ->(e) { request.format.json? ? render404(e) : raise(e) }
      rescue_from ActiveRecord::RecordNotUnique, with: ->(e) { request.format.json? ? render409(e) : raise(e) }
      rescue_from ActiveRecord::RecordInvalid, with: ->(e) { request.format.json? ? render422(e) : raise(e) }
      rescue_from UnauthorizedError, with: ->(e) { request.format.json? ? render401(e) : raise(e) }
    end

    class UnauthorizedError < StandardError
    end

    protected

    def render400(exception = nil, messages = nil)
      render_error(400, "Bad Request", exception&.message, *messages)
    end

    def render401(exception = nil, messages = nil)
      render_error(401, "Unauthorized", exception&.message, *messages)
    end

    def render404(exception = nil, messages = nil)
      render_error(404, "Not Found", exception&.message, *messages)
    end

    def render409(exception = nil, messages = nil)
      render_error(409, "Conflict", exception&.message, *messages)
    end

    def render422(exception = nil, messages = nil)
      render_error(422, "Unprocessable Entity", exception&.message, *messages)
    end

    def render500(exception = nil, messages = nil)
      logger.error exception.full_message
      # logger.error exception.backtrace
      render_error(500, "Internal Server Error", exception&.message, *messages)
    end

    def render_error(code, message, *error_messages)
      response = {
        message:,
        errors: error_messages.compact
      }

      render json: response, status: code
    end
  end
end
