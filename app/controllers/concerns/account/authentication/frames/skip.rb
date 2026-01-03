# frozen_string_literal: true

# account/authentication/frames/Skip module
module Account::Authentication::Frames::Skip
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!, only: %i[index show comments]
  end
end
