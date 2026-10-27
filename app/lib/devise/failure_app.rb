# frozen_string_literal: true

module Devise
  # Devise::FailureApp class
  class FailureApp
    prepend Vesper::Devise::JWT::FailureApp
  end
end
