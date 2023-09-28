# frozen_string_literal: true

# Pagination
module Pagination
  extend ActiveSupport::Concern

  def resources_with_pagination(pagy)
    {
      meta: {
        pagination: {
          count: pagy.count,
          pages: pagy.pages,
          page: pagy.page,
          per: pagy.items
        }
      }
    }
  end
end
