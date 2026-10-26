# frozen_string_literal: true

module Api
  module Pagination
    # Api::Pagination::Pagy class
    class Pagy
      def self.pagination_resource(pagy)
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
end
