# frozen_string_literal: true

SPEC_DIR_V1 = '/spec/requests/api/v1/'

RSpec.configure do |config|
  config.include Committee::Rails::Test::Methods

  config.before(:each, type: :request) do |example|
    # (各RequestSpecのディレクトリがどのAPIに該当するのかを識別する)
    path = example.metadata[:example_group][:file_path]
    directory = if path.include?(SPEC_DIR_V1)
      SPEC_DIR_V1
    end

    curr_directory = config.instance_variable_get(:@curr_directory)
    if curr_directory.nil? || directory != curr_directory
      case directory
      when SPEC_DIR_V1
        config.include CommitteeV1
      end
      config.instance_variable_set(:@curr_directory, directory)
    end
  end
end

module CommitteeV1
  def committee_options
    @committee_options ||= {
      schema_path: Rails.root.join('doc/openapi/v1.yaml').to_s,
      strict_reference_validation: true,
      parse_response_by_content_type: true
    }
  end
end
