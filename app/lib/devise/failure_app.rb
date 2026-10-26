# frozen_string_literal: true

require_relative "../vesper/devise/j_w_t/failure_app"

module Devise
  # Devise::FailureApp class
  class FailureApp
    prepend Vesper::Devise::JWT::FailureApp
  end
end
