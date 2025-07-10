# frozen_string_literal: true

# Application Controller
class ApplicationController < Api::V1::ApiController
  include ActionController::MimeResponds
  include ActionController::Flash
end
