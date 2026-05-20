# frozen_string_literal: true

# Form::Admins::Sessions::New::Component class
class Form::Admins::Sessions::New::Component < ViewComponent::Base
  def initialize(resource:, resource_name:)
    @resource = resource
    @resource_name = resource_name
  end
end
