# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Sessions', type: :request do
  describe 'POST /api/v1/sessions' do
    let(:endpoint) { '/api/v1/sessions' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }

    context 'login (ログイン)' do
      it 'success (成功)' do
        post endpoint,
             params: { user: { email: user.email, password: 'testtest' } },
             headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        expect(response.status).to eq(200)
        json_data = json[:data]
        expect(json_data).to have_type('user')
        expect(json_data).to have_attribute('name')
        expect(json_data).to have_attribute('email')
      end

      context 'failure (失敗)' do
        it 'invalid email (未登録のEメールアドレスの場合)' do
          post endpoint,
               params: { user: { email: 'invalid@test.jp', password: 'testtest' } },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:messages]).to be_present
        end

        it 'invalid password (パスワードが正しくない場合)' do
          post endpoint,
               params: { user: { email: user.email, password: 'invalidtest' } },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:messages]).to be_present
        end
      end
    end
  end

  describe 'GET /api/v1/profile' do
    let(:endpoint) { '/api/v1/profile' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    context 'authenticate token (トークン認証)' do
      it 'success (成功)' do
        get endpoint, headers: {
          'HTTP_ACCEPT_LANGUAGE': 'ja',
          'Authorization': "Bearer #{user.token}"
        }
        expect(response.status).to eq(200)
        json_data = json[:data]
        expect(json_data).to have_type('user')
        expect(json_data).to have_attribute('name')
        expect(json_data).to have_attribute('email')
      end
    end

    it 'failure (失敗)' do
      get endpoint, headers: {
        'HTTP_ACCEPT_LANGUAGE': 'ja',
        'Authorization': 'Bearer '
      }
      expect(response.status).to eq(401)
    end
  end

  describe 'DELETE /api/v1/sessions/logout' do
    let(:endpoint) { '/api/v1/sessions/logout' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    context 'logout (ログアウト)' do
      it 'success (成功)' do
        delete endpoint, headers: {
          'HTTP_ACCEPT_LANGUAGE': 'ja',
          'Authorization': "Bearer #{user.token}"
        }
        expect(response.status).to eq(200)
        json_data = json[:data]
        expect(json_data).to have_type('user')
        expect(json_data).to have_attribute('name')
        expect(json_data).to have_attribute('email')
      end
    end
  end

  describe 'DELETE /api/v1/profile' do
    let(:endpoint) { '/api/v1/profile' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    context 'delete (退会)' do
      it 'success (成功)' do
        delete endpoint, headers: {
          'HTTP_ACCEPT_LANGUAGE': 'ja',
          'Authorization': "Bearer #{user.token}"
        }
        expect(response.status).to eq(200)
        json_data = json[:data]
        expect(json_data).to have_type('user')
        expect(json_data).to have_attribute('name')
        expect(json_data).to have_attribute('email')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
