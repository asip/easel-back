# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Sessions', type: :request do
  describe 'POST /api/v1/sessions' do
    let_it_be(:endpoint) { '/api/v1/sessions' }
    let_it_be(:user) { create(:user, password: 'testtest') }

    context 'login (ログイン)' do
      it 'success (成功)' do
        post endpoint,
             params: { user: { email: user.email, password: 'testtest' } },
             headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        # expect(response.status).to eq(200)
        # puts response.headers
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      context 'failure (失敗)' do
        it 'invalid email (未登録のEメールアドレスの場合)' do
          post endpoint,
               params: { user: { email: 'invalid@test.jp', password: 'testtest' } },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          # json_data = json
          # expect(json_data[:messages]).to be_present
        end

        it 'invalid password (パスワードが正しくない場合)' do
          post endpoint,
               params: { user: { email: user.email, password: 'invalidtest' } },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          # json_data = json
          # expect(json_data[:messages]).to be_present
        end
      end
    end
  end

  describe 'GET /api/v1/account/profile' do
    let_it_be(:endpoint) { '/api/v1/account/profile' }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let!(:headers) { authenticated_headers(request, user) }

    context 'authenticate token (トークン認証)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        get endpoint, headers: headers
        # expect(response.status).to eq(200)
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end
    end

    it 'failure (失敗)' do
      get endpoint, headers: {
        'Accept': "application/json",
        'HTTP_ACCEPT_LANGUAGE': 'ja'
      }
      # expect(response.status).to eq(401)
      assert_request_schema_confirm
      assert_response_schema_confirm(401)
    end
  end

  describe 'DELETE /api/v1/sessions/logout' do
    let_it_be(:endpoint) { '/api/v1/sessions/logout' }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let!(:headers) { authenticated_headers(request, user) }

    context 'logout (ログアウト)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        delete endpoint, headers: headers
        # expect(response.status).to eq(204)
        assert_request_schema_confirm
        assert_response_schema_confirm(204)
        # json_data = json
      end
    end
  end

  describe 'DELETE /api/v1/account' do
    let_it_be(:endpoint) { '/api/v1/account' }
    let!(:user) { create(:user, password: 'testtest') }
    let!(:headers) { authenticated_headers(request, user) }

    context 'delete (退会)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        delete endpoint, headers: headers
        # expect(response.status).to eq(200)
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end
    end
  end

  describe 'GET /api/v1/account/frames/:id' do
    let(:endpoint) { "/api/v1/account/frames/#{frame.id}" }
    let_it_be(:endpoint_failure) { '/api/v1/account/frames/404' }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let!(:headers) { authenticated_headers(request, user) }

    context 'get frame (フレーム情報取得)' do
      context 'private = false' do
        let_it_be(:frame) { create(:frame, :skip_validate, user_id: user.id) }

        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          # json_data = json
        end

        it 'failure (失敗)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint_failure, headers: headers
          # expect(response.status).to eq 404
          assert_request_schema_confirm
        assert_response_schema_confirm(404)
        end
      end

      context 'private = true' do
        let_it_be(:frame) { create(:frame, :skip_validate, user_id: user.id, private: true) }

        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          # json_data = json
        end

        it 'failure (失敗)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint_failure, headers: headers
          # expect(response.status).to eq 404
          assert_request_schema_confirm
          assert_response_schema_confirm(404)
        end
      end
    end
  end

  describe 'GET /api/v1/account/frames' do
    let_it_be(:endpoint) { "/api/v1/account/frames" }
    let_it_be(:user) { create(:user, password: 'testtest') }

    before_all do
      create(:frame, :skip_validate, name: 'test00', tag_list: 'testA0', shooted_at: '2022/01/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test01', tag_list: 'testA1', shooted_at: '2022/01/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test12', tag_list: 'testB2', shooted_at: '2022/02/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test13', tag_list: 'testB3', shooted_at: '2022/02/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test24', tag_list: 'testC4', shooted_at: '2022/03/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test25', tag_list: 'testC5', shooted_at: '2022/03/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test36', tag_list: 'testC6', shooted_at: '2022/04/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test37', tag_list: 'testC7', shooted_at: '2022/04/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test48', tag_list: 'testD8', shooted_at: '2022/04/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test49', tag_list: 'testD9', shooted_at: '2022/04/01', user_id: user.id)
      # create(:frame, :skip_validate, name: 'test50', tag_list: 'testE0', shooted_at: '2022/04/01', user_id: user.id)
      # create(:frame, :skip_validate, name: 'test51', tag_list: 'testE1', shooted_at: '2022/04/01', user_id: user.id)
      # create(:frame, :skip_validate, name: 'test62', tag_list: 'testF2', shooted_at: '2022/04/01', user_id: user.id)
      # create(:frame, :skip_validate, name: 'test63', tag_list: 'testF3', shooted_at: '2022/04/01', user_id: user.id)
    end

    context "get login user's frame list (ログインユーザーのフレームリスト取得)" do
      let!(:headers) { authenticated_headers(request, user) }

      context 'page=1 (1ページめ)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'page=2 (2ページめ)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { page: 2 }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
