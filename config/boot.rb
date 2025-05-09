# ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
gemfile_path = File.expand_path("../Gemfile", __dir__)
gems_rb_path = File.expand_path("../gems.rb", __dir__)

unless ENV["BUNDLE_GEMFILE"] && File.exist?(ENV["BUNDLE_GEMFILE"])
  if File.exist?(gemfile_path)
    ENV["BUNDLE_GEMFILE"] = gemfile_path
  elsif File.exist?(gems_rb_path)
    ENV["BUNDLE_GEMFILE"] = gems_rb_path
  end
end

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup"
