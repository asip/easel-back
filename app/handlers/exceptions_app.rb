# frozen_string_literal: true

# ExceptionsApp class
class ExceptionsApp < Rambulance::ExceptionsApp
=begin
  include Api::Renderable

  # HTTP Status 400 Bad Request
  def bad_request
    render_error(:bad_request, "Bad Request")
  end

  # HTTP Status 401 Unauthorized
  def unauthorized
    # render_error(:unauthorized, "Unauthorized")
  end

  def forbidden
  end

  # HTTP Status 404 Not Found
  def not_found
    render_error(:not_found, "Not Found")
  end

  # HTTP Status 409 Conflict
  def conflict
    render_error(:conflict, "Conflict")
  end

  # HTTP Status 422 Unprocessable Content
  def unprocessable_content
    render_error(:unprocessable_content, "Unprocessable Content")
  end

  # HTTP Status 500 Internal Server Error
  def internal_server_error
    logger.error exception.full_message
    # logger.error exception.backtrace.join("\n") # backtrace

    render_error(:internal_server_error, "Internal Server Error")
  end

  protected

  def render_error(code, title)
    if request.format.json?
      code = Rack::Utils.status_code(code)

      error = {
        title:,
        errors: exception&.message ? [ exception&.message ] : []
      }

      if code == Rack::Utils.status_code(:not_found)
        error[:source] = exception.model
      end

      # puts error

      render_resource ErrorMapResource.new(ErrorMap.new(error)).serialize,
                      status: code: code
    end
  end
=end
end
