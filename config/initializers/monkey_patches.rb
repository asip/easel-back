# frozen_string_literal: true

PATCHES = [ Rails.root.join("app/lib/devise/**/*.rb"), Rails.root.join("app/lib/active_model/**/*.rb") ]

Dir[*PATCHES].sort.each do |file|
  require file
end
