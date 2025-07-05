# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Comments', type: :request do
  describe 'POST /api/v1/frames/:frame_id/comments' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}/comments" }
    let!(:user) { create(:user, password: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }
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
        expect(response.status).to eq 200
        json_data = json
        expect(json_data).to include(:body)
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
          expect(response.status).to eq 422
          json_data = json
          expect(json_data[:errors][:body]).to be_present
        end
      end
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    let(:endpoint) { "/api/v1/comments/#{comment.id}" }
    let(:endpoint_failure) { '/api/v1/comments/404' }
    let!(:user) { create(:user, password: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }
    let!(:comment) { create(:comment, frame_id: frame.id, user_id: user.id) }
    let!(:headers) { authenticated_headers(request, user) }

    context 'delete comment (コメント削除)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        delete endpoint, headers: headers
        expect(response.status).to eq 204
      end

      it 'failure (失敗)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        delete endpoint_failure, headers: headers
        expect(response.status).to eq 404
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
