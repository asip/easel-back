# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Sessions', type: :request do
  describe 'POST /api/v1/sessions' do
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let(:endpoint) { '/api/v1/sessions' }

    context 'login (ログイン)' do
      it 'success (成功)' do
        post endpoint,
             params: { user: { email: user.email, password: 'testtest' } },
             headers: { 'HTTP_ACCEPT_LANGUAGE' => 'jp' }
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
               headers: { 'HTTP_ACCEPT_LANGUAGE' => 'jp' }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:messages]).to be_present
        end

        it 'invalid password (パスワードが正しくない場合)' do
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

  describe 'GET /api/v1/profile' do
    let(:endpoint) { '/api/v1/profile' }

    before do
      @user = create(:user, password: 'testtest', password_confirmation: 'testtest')
      @user.assign_token(User.issue_token(id: @user.id, email: @user.email))
    end

    context 'authenticate token (トークン認証)' do
      it 'success (成功)' do
        get endpoint, headers: {
          'HTTP_ACCEPT_LANGUAGE' => 'jp',
          'Authorization': "Bearer #{@user.token}"
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
        'HTTP_ACCEPT_LANGUAGE' => 'jp',
        'Authorization': 'Bearer '
      }
      expect(response.status).to eq(401)
    end
  end
end
# rubocop:enable Metrics/BlockLength
