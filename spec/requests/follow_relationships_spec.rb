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
      let!(:headers) { authenticated_headers(request, user) }

      context 'not follow (フォロしていない場合)' do
        it 'success(成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, headers: headers
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
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, headers: headers
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
    let!(:headers) { authenticated_headers(request, user) }

    context 'follow (フォロー)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        post endpoint, headers: headers
        expect(response.status).to be 204
      end

      # it 'failure (失敗)' do
      #  rheaders.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
      #  post endpoint_failure,
      #       headers: headers
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
    let!(:headers) { authenticated_headers(request, user) }

    before do
      create(:follow_relationship, follower_id: user.id, followee_id: followee_user.id)
    end

    context 'unfollow (アンフォロー)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        delete endpoint, headers: headers
        expect(response.status).to be 204
      end

      it 'falure (失敗)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        delete endpoint_failure, headers: headers
        expect(response.status).to be 204
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
