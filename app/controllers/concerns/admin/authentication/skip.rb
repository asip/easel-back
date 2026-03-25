# Admin::Authentication::Skip module
module Admin::Authentication::Skip
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_admin!
  end
end
