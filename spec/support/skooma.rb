# frozen_string_literal: true

# SPEC_DIR_V1 = '/spec/requests/api/v1/'

# RSpec.configure do |config|
#  config.before(:each, type: :request) do |example|
#    # 各RequestSpecのディレクトリがどのAPIに該当するのかを識別する
#    path = example.metadata[:example_group][:file_path]
#    directory = if path.include?(SPEC_DIR_V1)
#      SPEC_DIR_V1
#    end
#
#    curr_directory = config.instance_variable_get(:@curr_directory)
#    if curr_directory.nil? || directory != curr_directory
#      case directory
#      when SPEC_DIR_V1
#        path_to_openapi = Rails.root.join('doc/openapi/v1.yaml')
#        config.include Skooma::RSpec[path_to_openapi], type: :request
#      end
#      config.instance_variable_set(:@curr_directory, directory)
#    end
#  end
# end
