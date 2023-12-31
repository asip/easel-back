# frozen_string_literal: true

module AuthHelpers
  shared_context :unauthorized do
    it 'returns 401(unauthorized) response' do
      expect(response.status).to eq(401)
    end
  end

  shared_context :authenticate_google_one_tap_user do
    before(:each) do
      allow(Google::Auth::IDTokens).to receive(:verify_oidc).and_return(
        {
          'name' => 'test_user',
          'email' => 'test@test.jp',
          'sub' => '123'
        }
      )
    end
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
