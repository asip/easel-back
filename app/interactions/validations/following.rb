# frozen_string_literal: true

# Validations::Following class
class Validations::Following
  include Validation

  def initialize(user:, followee:)
    @user = user
    @followee = followee
  end

  def execute
    @user.followees.include?(@followee)
  end
end
