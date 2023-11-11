# frozen_string_literal: true

#
# Monkey patch to remove default scope
#
require 'rails_admin/adapters/active_record'

# RaisAdmin
module RailsAdmin
  # Adapters
  module Adapters
    # ActiveRecord
    module ActiveRecord
      def scoped
        model.unscoped
      end
    end
  end
end

RailsAdmin.config do |config|
  config.asset_source = :webpack

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.authenticate_with do
    require_login
  end

  config.current_user_method(&:current_user)
  config.parent_controller = 'Manager::ApplicationController'

  config.default_hidden_fields = {
    show: %i[id created_at updated_at],
    edit: %i[id created_at updated_at]
  }

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  # config.model User do
  #  scope { User.unscoped }
  #  #list do
  #  #  scopes [:unscoped]
  #  # end
  # end
end
