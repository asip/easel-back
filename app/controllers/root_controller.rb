# frozen_string_literal: true

# Root Controller
class RootController < Admins::ApplicationController
  def index
    redirect_to "/admin"
  end
end
