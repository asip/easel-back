# frozen_string_literal: true

Dir[Rails.root.join("app/lib/devise/**/*.rb")].sort.each do |file|
  require file
end
