# frozen_string_literal: true

# mutations
module Mutations
  # users
  module Users
    # CreateUser
    class CreateUser
      include Mutation

      attr_reader :user

      def initialize(form_params:)
        @form_params = form_params
      end

      def execute
        @user = User.new(@form_params)
        return if @user.save # (context: :with_validation)

        errors.merge!(@user.errors)
      end
    end
  end
end
