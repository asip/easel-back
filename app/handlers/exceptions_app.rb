# frozen_string_literal: true

# ExceptionsApp class
class ExceptionsApp < Rambulance::ExceptionsApp
=begin
  include Api::Renderable

  # HTTP Status 400 Bad Request
  def bad_request
    render_error(:bad_request)
  end

  # HTTP Status 401 Unauthorized
  def unauthorized
    # render_error(:unauthorized)
  end

  def forbidden
  end

  # HTTP Status 404 Not Found
  def not_found
    render_error(:not_found)
  end

  # HTTP Status 409 Conflict
  def conflict
    render_error(:conflict)
  end

  # HTTP Status 422 Unprocessable Content
  def unprocessable_content
    render_error(:unprocessable_content)
  end

  # HTTP Status 500 Internal Server Error
  def internal_server_error
    logger.error exception.full_message
    # logger.error exception.backtrace.join("\n") # backtrace

    render_error(:internal_server_error)
  end

  protected

  def make_error_map(status)
    error = {
      title: status.to_s.titleize,
      detail: exception&.message
    }

    if status == :not_found
      error[:source] = exception.model
    end

    error
  end

  def render_error(status)
    if request.format.json?
      error = make_error_map(status)

      # puts error

      render_resource ErrorMapResource.new(ErrorMap.new(error)).serialize,
                      status:
    end
  end
=end
end
