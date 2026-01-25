# frozen_string_literal: true

# NPlusOne::Query::Detection module
module NPlusOne::Query::Detection
  extend ActiveSupport::Concern

  included do
    around_action :n_plus_one_detection
  end

  protected

  def n_plus_one_detection
    Prosopite.scan
    yield
  ensure
    Prosopite.finish
  end
end
