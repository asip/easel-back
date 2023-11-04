# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Comments', type: :request do
  describe 'POST /api/v1/frames/:frame_id/comments' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}/comments" }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    context 'regist comment (コメント登録)' do
      it 'success (成功)' do
        post endpoint,
             params: {
               comment: {
                 body: 'testtest'
               }
             },
             headers: {
               'HTTP_ACCEPT_LANGUAGE': 'jp',
               'Authorization': "Bearer #{user.token}"
             }
        expect(response.status).to eq 200
        json_data = json[:data]
        expect(json_data).to have_type('comment')
        expect(json_data).to have_attribute('body')
      end

      context 'failure (失敗)' do
        it 'empty body (bodyが空の場合)' do
          post endpoint,
               params: {
                 comment: {
                   body: ''
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
                 'Authorization': "Bearer #{user.token}"
               }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:body]).to be_present
        end

        it 'body exceeds 255 characters (bodyが255文字を超える場合)' do
          post endpoint,
               params: {
                 comment: {
                   body: Faker::Alphanumeric.alpha(number: 256)
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
                 'Authorization': "Bearer #{user.token}"
               }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:body]).to be_present
        end
      end
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    let(:endpoint) { "/api/v1/comments/#{comment.id}" }
    let(:endpoint_failure) { '/api/v1/comments/404' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }
    let!(:comment) { create(:comment, frame_id: frame.id, user_id: user.id) }

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    context 'delete comment (コメント削除)' do
      it 'success (成功)' do
        delete endpoint,
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
                 'Authorization': "Bearer #{user.token}"
               }
        expect(response.status).to eq 204
      end

      it 'failure (失敗)' do
        delete endpoint_failure,
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
                 'Authorization': "Bearer #{user.token}"
               }
        expect(response.status).to eq 404
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
