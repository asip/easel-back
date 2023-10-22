# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Users', type: :request do
  describe 'GET /api/v1/users/:id' do
    let(:endpoint) { "/api/v1/users/#{user.id}" }
    let(:endpoint_failure) { '/api/v1/users/404' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }

    context 'ユーザー情報取得' do
      it 'success (成功)' do
        get endpoint,
            headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
        json_data = json[:data]
        expect(response.status).to eq(200)
        expect(json_data).to have_type('user')
        expect(json_data).to have_attribute('name')
        expect(json_data).to have_attribute('email')
      end

      it 'failure (失敗)' do
        get endpoint_failure,
            headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST /api/v1/users' do
    let(:endpoint) { '/api/v1/users' }

    context 'regist user (ユーザー情報登録)' do
      context 'success (成功)' do
        it 'without image' do
          post endpoint,
               params: {
                 user: {
                   name: 'test_user01',
                   email: 'test@test.jp',
                   password: 'testtest',
                   password_confirmation: 'testtest'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
          json_data = json[:data]
          expect(json_data).to have_type('user')
          expect(json_data).to have_attribute('name')
          expect(json_data).to have_attribute('email')
        end
      end

      it 'with image' do
        post endpoint,
             params: {
               user: {
                 name: 'test_user01',
                 email: 'test@test.jp',
                 password: 'testtest',
                 password_confirmation: 'testtest',
                 image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
               }
             },
             headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
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
