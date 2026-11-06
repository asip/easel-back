# frozen_string_literal: true

# Account::Renderble module
module Account::Renderable
  extend ActiveSupport::Concern

  protected

  def render_account(account)
    render_resource AccountResource.new(account).serialize
  end
end
