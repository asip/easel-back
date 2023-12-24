# frozen_string_literal: true

Dir[Rails.root.join('lib/sorcery/**/*.rb')].sort.each do |file|
  require file
end
