# frozen_string_literal: true

# ExceptionsApp class
class ExceptionsApp < Rambulance::ExceptionsApp
  # HTTP Status 400 Bad Request
  def bad_request
    render_error(400, "Bad Request")
  end

  # HTTP Status 401 Unauthorized
  def unauthorized
    # render_error(401, "Unauthorized")
  end

  def forbidden
  end

  # HTTP Status 404 Not Found
  def not_found
    render_error(404, "Not Found")
  end

  # HTTP Status 409 Conflict
  def conflict
    render_error(409, "Conflict")
  end

  # HTTP Status 422 Unprocessable Content
  def unprocessable_content
    render_error(422, "Unprocessable Content")
  end

  # HTTP Status 500 Internal Server Error
  def internal_server_error
    logger.error exception.full_message
    # logger.error exception.backtrace.join("\n") # backtrace

    render_error(500, "Internal Server Error")
  end

  protected

  def render_error(code, title)
    if request.format.json?
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
end
