# frozen_string_literal: true

require 'rails_helper'

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
end
