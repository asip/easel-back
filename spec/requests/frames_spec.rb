# frozen_string_literal: true

require 'rails_helper'

describe 'Frames', type: :request do
  describe 'GET /api/v1/frames/:id' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}" }
    let(:endpoint_failure) { '/api/v1/frames/404' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }

    context 'get frame (フレーム情報取得)' do
      it 'success (成功)' do
        get endpoint, headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
        expect(response.status).to eq 200
        json_data = json[:data]
        expect(json_data).to have_type('frame')
        expect(json_data).to have_attribute('name')
      end

      it 'failure (失敗)' do
        get endpoint_failure, headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
        expect(response.status).to eq 404
      end
    end
  end
end
