module Login
  # Authentication module
  module Authentication
    extend ActiveSupport::Concern

    class_methods do
      def create_from(user:, provider:, uid:)
        authentication = ::Authentication.new(user:, provider:, uid:)
        authentication.save!
      end
    end
  end
end
