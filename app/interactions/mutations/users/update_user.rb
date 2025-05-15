# frozen_string_literal: true

# mutations
module Mutations
  # users
  module Users
    # UpdateUser
    class UpdateUser
      include Mutation

      attr_reader :user

      def initialize(user:, form_params:)
        @user = user
        @form_params = form_params
      end

      def execute
        @user.attributes = @form_params
        # puts 'testtest'
        success = @user.valid? # (:with_validation)
        if success
          ApplicationRecord.transaction do
            @user.save! # (context: :with_validation)
            # @user.update_token
          end
        else
          errors.merge!(@user.errors)
        end
      end
    end
  end
end
