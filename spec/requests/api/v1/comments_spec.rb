# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Comments', type: :request do
  describe 'POST /api/v1/frames/:frame_id/comments' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}/comments" }
    let_it_be(:endpoint_frame_not_found_failure) { "/api/v1/frames/404/comments" }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let_it_be(:frame) { create(:frame, :skip_validate, user_id: user.id) }
    let!(:headers) { authenticated_headers(request, user) }

    context 'regist comment (コメント登録)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        post endpoint,
             params: {
               comment: {
                 body: 'testtest'
               }
             },
             headers: headers
        # expect(response.status).to eq 200
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      context 'failure (失敗)' do
        it 'empty body (bodyが空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint,
               params: {
                 comment: {
                   body: ''
                 }
               },
               headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:body]).to be_present
        end

        it 'frame has been deleted (frame削除済み)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint_frame_not_found_failure,
               params: {
                 comment: {
                   body: ''
                 }
               },
               headers: headers
          # expect(response.status).to eq 404
          assert_request_schema_confirm
          assert_response_schema_confirm(404)
        end
      end
    end
  end

  describe 'PUT /api/v1/frames/:frame_id/comments/:id' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}/comments/#{comment.id}" }
    let_it_be(:endpoint_frame_not_found_failure) { "/api/v1/frames/404/comments/404" }
    let(:endpoint_comment_not_found_failure) { "/api/v1/frames/#{frame.id}/comments/404" }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let_it_be(:frame) { create(:frame, :skip_validate, user_id: user.id) }
    let!(:comment) { create(:comment, frame_id: frame.id, user_id: user.id) }
    let!(:headers) { authenticated_headers(request, user) }

    context 'update comment (コメント更新)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        put endpoint,
            params: {
              comment: {
                body: 'testtest'
              }
            },
            headers: headers
        # expect(response.status).to eq 200
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      context 'failure (失敗)' do
        it 'empty body (bodyが空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                comment: {
                  body: ''
                }
              },
              headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:body]).to be_present
        end

        it 'frame has been deleted (フレーム削除済み)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint_frame_not_found_failure,
              params: {
                comment: {
                  body: 'testtest'
                }
              },
              headers: headers
          # expect(response.status).to eq 404
          assert_request_schema_confirm
          assert_response_schema_confirm(404)
        end

        it 'comment has been deleted (コメント削除済み)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint_comment_not_found_failure,
              params: {
                comment: {
                  body: 'testtest'
                }
              },
              headers: headers
          # expect(response.status).to eq 404
          assert_request_schema_confirm
          assert_response_schema_confirm(404)
        end
      end
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}/comments/#{comment.id}" }
    let_it_be(:endpoint_frame_not_found_failure) { "/api/v1/frames/404/comments/404" }
    let(:endpoint_comment_not_found_failure) { "/api/v1/frames/#{frame.id}/comments/404" }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let_it_be(:frame) { create(:frame, :skip_validate, user_id: user.id) }
    let!(:comment) { create(:comment, frame_id: frame.id, user_id: user.id) }
    let!(:headers) { authenticated_headers(request, user) }

    context 'delete comment (コメント削除)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        delete endpoint, headers: headers
        # expect(response.status).to eq 204
        assert_request_schema_confirm
        assert_response_schema_confirm(204)
      end

      context 'failure (失敗)' do
        it 'frame has been deleted (フレーム削除済み)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          delete endpoint_frame_not_found_failure, headers: headers
          # expect(response.status).to eq 404
          assert_request_schema_confirm
          assert_response_schema_confirm(404)
        end

        it 'comment has been deleted (コメント削除済み)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          delete endpoint_comment_not_found_failure, headers: headers
          # expect(response.status).to eq 404
          assert_request_schema_confirm
          assert_response_schema_confirm(404)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
