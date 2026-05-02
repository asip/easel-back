# frozen_string_literal: true

# api
module Api
  # Pagination Class
  class Pagination
    def self.pagination_resources(pagy)
      {
        pagination: {
          count: pagy.count,
          pages: pagy.pages,
          page: pagy.page,
          per: pagy.limit
        }
      }
    end
  end
end
