# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'FollowRelationships', type: :request do
  describe 'GET /api/v1/account/following/:user_id' do
    context 'get following (boolean value) (フォローしているかを取得する)' do
      let(:endpoint) { "/api/v1/account/following/#{followee_user.id}" }
      let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
      let!(:followee_user) do
        create(:user, name: 'test_user2', email: 'test2@test.jp',
                      password: 'testtest', password_confirmation: 'testtest')
      end

      before do
        user.assign_token(User.issue_token(id: user.id, email: user.email))
      end

      context 'not follow (フォロしていない場合)' do
        it 'success(成功)' do
          get endpoint,
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'ja',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to be 200
          json_data = json
          expect(json_data[:following]).to be false
        end
      end

      context 'follow (フォローしている場合)' do
        before do
          create(:follow_relationship, follower_id: user.id, followee_id: followee_user.id)
        end

        it 'success(成功)' do
          get endpoint,
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'ja',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to be 200
          json_data = json
          expect(json_data[:following]).to be true
        end
      end
    end
  end

  describe 'POST /api/v1/user/:user_id/follow_relationships' do
    let(:endpoint) { "/api/v1/users/#{followee_user.id}/follow_relationships" }
    # let(:endpoint_failure) { '/api/v1/users/404/follow_relationships' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let!(:followee_user) do
      create(:user, name: 'test_user2', email: 'test2@test.jp',
                    password: 'testtest', password_confirmation: 'testtest')
    end

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    context 'follow (フォロー)' do
      it 'success (成功)' do
        post endpoint,
             headers: {
               'HTTP_ACCEPT_LANGUAGE': 'ja',
               'Authorization': "Bearer #{user.token}"
             }
        expect(response.status).to be 204
      end

      # it 'failure (失敗)' do
      #  post endpoint_failure,
      #       headers: {
      #         'HTTP_ACCEPT_LANGUAGE': 'ja',
      #         'Authorization': "Bearer #{user.token}"
      #       }
      #  expect(response.status).to be 204
      # end
    end
  end

  describe 'DELETE /api/v1/user/:user_id/follow_relationships' do
    let(:endpoint) { "/api/v1/users/#{followee_user.id}/follow_relationships" }
    let(:endpoint_failure) { '/api/v1/users/404/follow_relationships' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let!(:followee_user) do
      create(:user, name: 'test_user2', email: 'test2@test.jp',
                    password: 'testtest', password_confirmation: 'testtest')
    end

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
      create(:follow_relationship, follower_id: user.id, followee_id: followee_user.id)
    end

    context 'unfollow (アンフォロー)' do
      it 'success (成功)' do
        delete endpoint,
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
        expect(response.status).to be 204
      end

      it 'falure (失敗)' do
        delete endpoint_failure,
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
        expect(response.status).to be 204
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
