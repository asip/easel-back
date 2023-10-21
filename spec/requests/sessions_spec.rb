# frozen_string_literal: true

require 'rails_helper'

describe 'Sessions', type: :request  do
  describe 'POST /api/v1/sessions' do
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let(:endpoint) { '/api/v1/sessions' }

    context 'login' do
      it 'success' do
        post endpoint,
             params: { user: { email: user.email, password: 'testtest' } },
             headers: { 'HTTP_ACCEPT_LANGUAGE' => 'jp' }
        expect(json[:data]).to have_type('user')
        expect(json[:data]).to have_attribute('name')
        expect(json[:data]).to have_attribute('email')
        expect(response.status).to eq(200)
      end
    end
  end
end
