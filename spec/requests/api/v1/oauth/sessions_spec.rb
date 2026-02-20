# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'oauth/sessions', type: :request do
  include_context :authenticate_google_one_tap_user

  describe 'POST /api/v1/oauth/sessions' do
    let_it_be(:endpoint) { '/api/v1/oauth/sessions' }
    let!(:headers) { { 'HTTP_ACCEPT_LANGUAGE': 'ja', 'Time-Zone': 'Asia/Tokyo' } }

    context 'login (ログイン)' do
      context 'no account registerd (アカウント未登録の場合)' do
        it 'success (成功)' do
          post endpoint,
               params: { provider: 'google', credential: 'test_credential' },
               headers: headers
          # expect(response.status).to eq(200)
          ## puts response.headers
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          # json_data = json
        end
      end

      context 'account registered (アカウント登録済の場合)' do
        let_it_be(:user) { create(:user, password: 'testtest') }

        context 'not linked (未連携の場合)' do
          it 'success (成功)' do
            post endpoint,
                 params: { provider: 'google', credential: 'test_credential' },
                 headers: headers
            # expect(response.status).to eq(200)
            ## puts response.headers
            assert_request_schema_confirm
            assert_response_schema_confirm(200)
            # json_data = json
          end
        end

        context 'linked (連携済みの場合)' do
          before_all do
            create(:authentication, user_id: user.id, provider: 'google', uid: '123')
          end

          it 'success (成功)' do
            post endpoint,
                 params: { provider: 'google', credential: 'test_credential' },
                 headers: headers
            # expect(response.status).to eq(200)
            ## puts response.headers
            assert_request_schema_confirm
            assert_response_schema_confirm(200)
            # json_data = json
          end
        end
      end

      context 'account withdrawed (アカウント退会済の場合)' do
        let_it_be(:user) { create(:user, password: 'testtest', deleted_at: Time.zone.now) }

        context 'not linked (未連携の場合)' do
          it 'success (成功)' do
            post endpoint,
                 params: { provider: 'google', credential: 'test_credential' },
                 headers: headers
            # expect(response.status).to eq(200)
            ## puts response.headers
            assert_request_schema_confirm
            assert_response_schema_confirm(200)
            # json_data = json
          end
        end

        context 'linked (連携済みの場合)' do
          before_all do
            create(:authentication, user_id: user.id, provider: 'google', uid: '123')
          end

          it 'success (成功)' do
            post endpoint,
                 params: { provider: 'google', credential: 'test_credential' },
                 headers: headers
            # expect(response.status).to eq(200)
            ## puts response.headers
            assert_request_schema_confirm
            assert_response_schema_confirm(200)
            # json_data = json
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
