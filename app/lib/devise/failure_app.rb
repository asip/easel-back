# frozen_string_literal: true

require_relative "../vesper/devise/j_w_t/failure_app"

# devise
module Devise
  # Failure App
  class FailureApp
    prepend Vesper::Devise::JWT::FailureApp
  end
end
