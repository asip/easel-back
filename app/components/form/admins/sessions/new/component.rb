# frozen_string_literal: true

# form
module Form
  # admins
  module Admins
    # sessions
    module Sessions
      # new
      module New
        # Component class
        class Component < ViewComponent::Base
          def initialize(resource:, resource_name:)
            @resource = resource
            @resource_name = resource_name
          end
        end
      end
    end
  end
end
