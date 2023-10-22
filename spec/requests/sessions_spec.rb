# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Sessions', type: :request do
  describe 'POST /api/v1/sessions' do
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let(:endpoint) { '/api/v1/sessions' }

    context 'login' do
      it 'success' do
        post endpoint,
             params: { user: { email: user.email, password: 'testtest' } },
             headers: { 'HTTP_ACCEPT_LANGUAGE' => 'jp' }
        json_data = json[:data]
        expect(json_data).to have_type('user')
        expect(json_data).to have_attribute('name')
        expect(json_data).to have_attribute('email')
        expect(response.status).to eq(200)
      end

      context 'failure' do
        it 'invalid email' do
          post endpoint,
               params: { user: { email: 'invalid@test.jp', password: 'testtest' } },
               headers: { 'HTTP_ACCEPT_LANGUAGE' => 'jp' }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:messages]).to be_present
        end

        it 'invalid password' do
          post endpoint,
               params: { user: { email: user.email, password: 'invalidtest' } },
               headers: { 'HTTP_ACCEPT_LANGUAGE' => 'jp' }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:messages]).to be_present
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
