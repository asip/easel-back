# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Frames', type: :request do
  describe 'GET /api/v1/frames' do
    let_it_be(:endpoint) { '/api/v1/frames' }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let_it_be(:tag1) { create(:application_tag, name: 'testA0') }
    let_it_be(:tag2) { create(:application_tag, name: 'testA1') }

    before_all do
      frame_01 = create(:frame, :skip_validate, user: user, name: 'test00', tag_list: 'testA0', shooted_at: '2022/01/01')
      create(:application_tagging, tag_id: tag1.id, taggable_id: frame_01.id)
      frame_02 = create(:frame, :skip_validate, user: user, name: 'test01', tag_list: 'testA1', shooted_at: '2022/01/01')
      create(:application_tagging, tag_id: tag2.id, taggable_id: frame_02.id)
      create(:frame, :skip_validate, user: user, name: 'test12', tag_list: 'testB2', shooted_at: '2022/02/01')
      create(:frame, :skip_validate, user: user, name: 'test13', tag_list: 'testB3', shooted_at: '2022/02/01')
      create(:frame, :skip_validate, user: user, name: 'test24', tag_list: 'testC4', shooted_at: '2022/03/01')
      create(:frame, :skip_validate, user: user, name: 'test25', tag_list: 'testC5', shooted_at: '2022/03/01')
      create(:frame, :skip_validate, user: user, name: 'test36', tag_list: 'testC6', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test37', tag_list: 'testC7', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test48', tag_list: 'testD8', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test49', tag_list: 'testD9', shooted_at: '2022/04/01')
      # create(:frame, :skip_validate, user: user, name: 'test50', tag_list: 'testE0', shooted_at: '2022/04/01')
      # create(:frame, :skip_validate, user: user, name: 'test51', tag_list: 'testE1', shooted_at: '2022/04/01')
      # create(:frame, :skip_validate, user: user, name: 'test62', tag_list: 'testF2', shooted_at: '2022/04/01')
      # create(:frame, :skip_validate, user: user, name: 'test63', tag_list: 'testF3', shooted_at: '2022/04/01')
    end

    context 'get frame list (フレームリスト取得)' do
      context 'page=1 (1ページめ)' do
        it 'success (成功)' do
          get endpoint, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'page=2 (2ページめ)' do
        it 'success (成功)' do
          get endpoint, params: { page: 2 }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "word": "test1" } (frame name)' do
        it 'success (成功)' do
          get endpoint, params: { q: { word: 'test1' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "word": "testA" } (tag name)' do
        it 'success (成功)' do
          get endpoint, params: { q: { word: 'testA' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "word": "test" } (user name)' do
        it 'success (成功)' do
          get endpoint, params: { q: { word: 'test' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "word": "test_creator" } (creator name)' do
        it 'success (成功)' do
          get endpoint, params: { q: { word: 'test_creator' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "word": "2022/01/01" } (shooted_at)' do
        it 'success (成功)' do
          get endpoint, params: { q: { word: '2022/01/01' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "word": Time.zone.today } (created_at / updated_at)' do
        it 'success (成功)' do
          get endpoint, params: { q: { word: Time.zone.today.strftime('%Y/%m/%d') }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "frame_name": "test1" } (frame name)' do
        it 'success (成功)' do
          get endpoint, params: { q: { frame_name: 'test1' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "tag_name": "testA" } (tag name)' do
        it 'success (成功)' do
          get endpoint, params: { q: { tag_name: 'testA' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "user_name": "test" } (user name)' do
        it 'success (成功)' do
          get endpoint, params: { q: { user_name: 'test' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "creator_name": "test_creator" } (creator name)' do
        it 'success (成功)' do
          get endpoint, params: { q: { creator_name: 'test_creator' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "date": "2022/01/01" } (shooted_at)' do
        it 'success (成功)' do
          get endpoint, params: { q: { date: '2022/01/01' }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "date": Time.zone.today } (created_at / updated_at)' do
        it 'success (成功)' do
          get endpoint, params: { q: { date: Time.zone.today.strftime('%Y/%m/%d') }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

       context 'q={ "word": exceeds 40 characters }' do
        it 'failure (失敗)' do
          get endpoint, params: { q: { word: Faker::Alphanumeric.alpha(number: 41) }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:word]).to be_present
        end
      end

      context 'q={ "frame_name": exceeds 30 characters } (frame name)' do
        it 'failure (失敗)' do
          get endpoint, params: { q: { frame_name: Faker::Alphanumeric.alpha(number: 31) }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:frame_name]).to be_present
        end
      end

      context 'q={ "tag_name": exceeds 10 characters } (tag name)' do
        it 'failure (失敗)' do
          get endpoint, params: { q: { tag_name: Faker::Alphanumeric.alpha(number: 11) }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:tag_name]).to be_present
        end
      end

      context 'q={ "user_name": exceeds 40 characters } (user name)' do
        it 'failure (失敗)' do
          get endpoint, params: { q: { user_name: Faker::Alphanumeric.alpha(number: 41) }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:user_name]).to be_present
        end
      end

      context 'q={ "creator_name": exceeds 40 characters } (creator name)' do
        it 'failure (失敗)' do
          get endpoint, params: { q: { creator_name: Faker::Alphanumeric.alpha(number: 41) }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:creator_name]).to be_present
        end
      end

      context 'q={ "date": invalid date } (date)' do
        it 'failure (失敗)' do
          get endpoint, params: { q: { date: "AAAA/AA/AA" }.to_json }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:date]).to be_present
        end
      end
    end
  end

  describe 'GET /api/v1/frames/authenticated' do
    let_it_be(:endpoint) { '/api/v1/frames/authenticated' }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let_it_be(:tag1) { create(:application_tag, name: 'testA0') }
    let_it_be(:tag2) { create(:application_tag, name: 'testA1') }
    let!(:headers) { authenticated_headers(request, user) }

    before_all do
      frame_01 = create(:frame, :skip_validate, user: user, name: 'test00', tag_list: 'testA0', shooted_at: '2022/01/01')
      create(:application_tagging, tag_id: tag1.id, taggable_id: frame_01.id)
      frame_02 = create(:frame, :skip_validate, user: user, name: 'test01', tag_list: 'testA1', shooted_at: '2022/01/01')
      create(:application_tagging, tag_id: tag2.id, taggable_id: frame_02.id)
      create(:frame, :skip_validate, user: user, name: 'test12', tag_list: 'testB2', shooted_at: '2022/02/01', private: true)
      create(:frame, :skip_validate, user: user, name: 'test13', tag_list: 'testB3', shooted_at: '2022/02/01', private: true)
      create(:frame, :skip_validate, user: user, name: 'test24', tag_list: 'testC4', shooted_at: '2022/03/01', private: true)
      create(:frame, :skip_validate, user: user, name: 'test25', tag_list: 'testC5', shooted_at: '2022/03/01', private: true)
      create(:frame, :skip_validate, user: user, name: 'test36', tag_list: 'testC6', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test37', tag_list: 'testC7', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test48', tag_list: 'testD8', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test49', tag_list: 'testD9', shooted_at: '2022/04/01')
      # create(:frame, :skip_validate, user: user, name: 'test50', tag_list: 'testE0', shooted_at: '2022/04/01')
      # create(:frame, :skip_validate, user: user, name: 'test51', tag_list: 'testE1', shooted_at: '2022/04/01')
      # create(:frame, :skip_validate, user: user, name: 'test62', tag_list: 'testF2', shooted_at: '2022/04/01')
      # create(:frame, :skip_validate, user: user, name: 'test63', tag_list: 'testF3', shooted_at: '2022/04/01')
    end

    context 'get frame list (フレームリスト取得)' do
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

      context 'q={ "word": "test1" } (frame name)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { word: 'test1' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "word": "testA" } (tag name)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { word: 'testA' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "word": "test" } (user name)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { word: 'test' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "word": "test_creator" } (creator name)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { word: 'test_creator' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "word": "2022/01/01" } (shooted_at)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { word: '2022/01/01' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "word": Time.zone.today } (created_at / updated_at)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { word: Time.zone.today.strftime('%Y/%m/%d') }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "frame_name": "test1" } (frame name)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { frame_name: 'test1' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "tag_name": "testA" } (tag name)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { tag_name: 'testA' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "user_name": "test" } (user name)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { user_name: 'test' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "creator_name": "test_creator" } (creator name)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { creator_name: 'test_creator' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

      context 'q={ "date": "2022/01/01" } (shooted_at)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { date: '2022/01/01' }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 2
        end
      end

      context 'q={ "date": Time.zone.today } (created_at / updated_at)' do
        it 'success (成功)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { date: Time.zone.today.strftime('%Y/%m/%d') }.to_json }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:frames]
          expect(json_data.size).to be 8
        end
      end

       context 'q={ "word": exceeds 40 characters }' do
        it 'failure (失敗)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { word: Faker::Alphanumeric.alpha(number: 41) }.to_json }, headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:word]).to be_present
        end
      end

      context 'q={ "frame_name": exceeds 30 characters } (frame name)' do
        it 'failure (失敗)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { frame_name: Faker::Alphanumeric.alpha(number: 31) }.to_json }, headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:frame_name]).to be_present
        end
      end

      context 'q={ "tag_name": exceeds 10 characters } (tag name)' do
        it 'failure (失敗)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { tag_name: Faker::Alphanumeric.alpha(number: 11) }.to_json }, headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:tag_name]).to be_present
        end
      end

      context 'q={ "user_name": exceeds 40 characters } (user name)' do
        it 'failure (失敗)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { user_name: Faker::Alphanumeric.alpha(number: 41) }.to_json }, headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:user_name]).to be_present
        end
      end

      context 'q={ "creator_name": exceeds 40 characters } (creator name)' do
        it 'failure (失敗)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { creator_name: Faker::Alphanumeric.alpha(number: 41) }.to_json }, headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:creator_name]).to be_present
        end
      end

      context 'q={ "date": invalid date } (date)' do
        it 'failure (失敗)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          get endpoint, params: { q: { date: "AAAA/AA/AA" }.to_json }, headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:date]).to be_present
        end
      end
    end
  end

  describe 'GET /api/v1/frames/:id' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}" }
    let_it_be(:endpoint_failure) { '/api/v1/frames/404' }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let_it_be(:frame) { create(:frame, :skip_validate, user_id: user.id) }

    context 'get frame (フレーム情報取得)' do
      it 'success (成功)' do
        get endpoint, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        # expect(response.status).to eq 200
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      it 'failure (失敗)' do
        get endpoint_failure, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        # expect(response.status).to eq 404
        assert_request_schema_confirm
        assert_response_schema_confirm(404)
      end
    end
  end

  describe 'GET /api/v1/frames/:frame_id/authenticated' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}/authenticated" }
    let_it_be(:endpoint_failure) { '/api/v1/frames/404/authenticated' }
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

  describe 'GET /api/v1/frames/:frame_id/comments' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}/comments" }
    let_it_be(:endpoint_failure) { '/api/v1/frames/404/comments' }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let_it_be(:frame) { create(:frame, :skip_validate, user_id: user.id) }

    before_all do
      create(:comment, body: 'comment01', frame_id: frame.id, user_id: user.id)
      create(:comment, body: 'comment02', frame_id: frame.id, user_id: user.id)
    end

    context 'get frame comment list (フレームのコメントリスト取得)' do
      it 'success (成功)' do
        get endpoint, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        # expect(response.status).to eq 200
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        json_data = json[:comments]
        expect(json_data.size).to be 2
      end

      context 'failure (失敗)' do
        it 'frame_id doesn\'t exist' do
          get endpoint_failure, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq 404
          assert_request_schema_confirm
          assert_response_schema_confirm(404)
        end
      end
    end
  end

  describe 'POST /api/v1/frames' do
    let_it_be(:endpoint) { '/api/v1/frames' }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let(:file_1024) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
    }
    let(:file_over_capacity) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/over_capacity.jpg'), 'image/jpeg')
    }
    let(:file_different_mime_type) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/different_mime_type.txt'), 'text/plain')
    }
    let!(:headers) { authenticated_headers(request, user) }

    describe 'regist frame (フレーム情報登録)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        post endpoint,
             params: {
               frame: {
                 name: 'test_frame',
                 tag_list: 'test',
                 comment: 'testtest',
                 creator_name: 'test_creator',
                 shooted_at: Time.zone.now,
                 private: true,
                 file: file_1024
               }
             },
             headers: headers
        # expect(response.status).to eq 200
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      context 'failure (失敗)' do
        it 'empty name (名前が空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint,
               params: {
                 frame: {
                   name: '',
                   tag_list: 'test',
                   comment: 'testtest',
                   creator_name: 'test_creator',
                   shooted_at: Time.zone.now,
                   file: file_1024
                 }
               },
               headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'name exceeds 30 characters (名前が30文字を超える場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint,
               params: {
                 frame: {
                   name: Faker::Alphanumeric.alpha(number: 31),
                   tag_list: 'test',
                   comment: 'testtest',
                   creator_name: 'test_creator',
                   shooted_at: Time.zone.now,
                   file: file_1024
                 }
               },
               headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'tag exceeds 10 characters (タグが10文字を超える場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint,
               params: {
                 frame: {
                   name: Faker::Alphanumeric.alpha(number: 21),
                   tag_list: Faker::Alphanumeric.alpha(number: 11),
                   comment: 'testtest',
                   creator_name: 'test_creator',
                   shooted_at: Time.zone.now,
                   file: file_1024
                 }
               },
               headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:tag_list]).to be_present
        end

        it 'creator_name exceeds 40 characters (撮影者名/作者名が40文字を超える場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint,
               params: {
                 frame: {
                   name: 'test_frame',
                   tag_list: 'test',
                   comment: 'testtest',
                   creator_name: Faker::Alphanumeric.alpha(number: 41),
                   shooted_at: Time.zone.now,
                   file: file_1024
                 }
               },
               headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:creator_name]).to be_present
        end

        it 'shooted_at is invalid' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint,
               params: {
                 frame: {
                   name: 'test_frame',
                   tag_list: 'test',
                   comment: 'testtest',
                   creator_name: 'test_creator',
                   shooted_at: 'aaa',
                   file: file_1024
                 }
               },
               headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:shooted_at]).to be_present
        end

        it 'private is invalid' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint,
               params: {
               frame: {
                 name: 'test_frame',
                 tag_list: 'test',
                 comment: 'testtest',
                 creator_name: 'test_creator',
                 shooted_at: Time.zone.now,
                 private: 'test',
                 file: file_1024
               }
             },
             headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:private]).to be_present
        end

        it 'empty file (file が空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja', 'Content-Type': 'multipart/form-data' })
          post endpoint,
               params: {
                 frame: {
                   name: 'test_frame',
                   tag_list: 'test',
                   comment: 'testtest',
                   creator_name: 'test_creator',
                   shooted_at: Time.zone.now
                 }
               },
               headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end

        it 'file exceeds 5mb (fileが5MBを超えている場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint,
               params: {
                 frame: {
                   name: 'test_frame',
                   tag_list: 'test',
                   comment: 'testtest',
                   creator_name: 'test_creator',
                   shooted_at: Time.zone.now,
                   file: file_over_capacity
                 }
               },
               headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end

        it 'file mime type is different (fileのmime typeが異なる場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          post endpoint,
               params: {
                 frame: {
                   name: 'test_frame',
                   tag_list: 'test',
                   comment: 'testtest',
                   creator_name: 'test_creator',
                   shooted_at: Time.zone.now,
                   file: file_different_mime_type
                 }
               },
               headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end
      end
    end
  end

  describe 'PUT /api/v1/frames/:id' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}" }
    let_it_be(:endpoint_frame_not_found_failure) { "/api/v1/frames/404" }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }
    let(:file_1024) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
    }
    let(:file_over_capacity) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/over_capacity.jpg'), 'image/jpeg')
    }
    let(:file_different_mime_type) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/different_mime_type.txt'), 'text/plain')
    }
    let!(:headers) { authenticated_headers(request, user) }

    describe 'update frame (フレーム情報更新)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        put endpoint,
            params: {
              frame: {
                name: 'test_frame',
                tag_list: 'test',
                comment: 'testtest',
                creator_name: 'test_creator',
                shooted_at: Time.zone.now,
                file: file_1024,
                private: false
              }
            },
            headers: headers
        # expect(response.status).to eq 200
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      context 'failure (失敗)' do
        it 'empty name (名前が空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                frame: {
                  name: '',
                  tag_list: 'test',
                  comment: 'testtest',
                  creator_name: 'test_creator',
                  shooted_at: Time.zone.now,
                  file: file_1024
                }
              },
              headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'name exceeds 30 characters (名前が30文字を超える場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                frame: {
                  name: Faker::Alphanumeric.alpha(number: 31),
                  tag_list: 'test',
                  comment: 'testtest',
                  creator_name: 'test_creator',
                  shooted_at: Time.zone.now,
                  file: file_1024
                }
              },
              headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'tag exceeds 10 characters (タグが10文字を超える場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                frame: {
                  name: Faker::Alphanumeric.alpha(number: 21),
                  tag_list: Faker::Alphanumeric.alpha(number: 11),
                  comment: 'testtest',
                  creator_name: 'test_creator',
                  shooted_at: Time.zone.now,
                  file: file_1024
                }
              },
              headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:tag_list]).to be_present
        end

        it 'creator_name exceeds 40 characters (撮影者名/作者名が40文字を超える場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  creator_name: Faker::Alphanumeric.alpha(number: 41),
                  shooted_at: Time.zone.now,
                  file: file_1024
                }
              },
              headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:creator_name]).to be_present
        end

        it 'shooted_at is invalid' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  creator_name: 'test_creator',
                  shooted_at: 'aaa',
                  file: file_1024
                }
              },
              headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:shooted_at]).to be_present
        end

        it 'private is invalid' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  creator_name: 'test_creator',
                  shooted_at: Time.zone.now,
                  private: 'test',
                  file: file_1024
                }
              },
              headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:private]).to be_present
        end

        it 'empty file (file が空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja', 'Content-Type': 'multipart/form-data' })
          put endpoint,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  creator_name: 'test_creator',
                  shooted_at: Time.zone.now
                }
              },
              headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end

        it 'file exceeds 5mb (fileが5MBを超えている場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  creator_name: 'test_creator',
                  shooted_at: Time.zone.now,
                  file: file_over_capacity
                }
              },
              headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end

        it 'file mime type is different (fileのmime typeが異なる場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  creator_name: 'test_creator',
                  shooted_at: Time.zone.now,
                  file: file_different_mime_type
                }
              },
              headers: headers
          # expect(response.status).to eq 422
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end

        it 'frame has been deleted (frame削除済み)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint_frame_not_found_failure,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  creator_name: 'test_creator',
                  shooted_at: Time.zone.now,
                  file: file_different_mime_type
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

  describe 'DELETE /api/v1/frames/:id' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}" }
    let_it_be(:endpoint_frame_not_found_failure) { '/api/v1/frames/404' }
    let_it_be(:user) { create(:user, password: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }
    let!(:headers) { authenticated_headers(request, user) }

    context 'delete frame (フレーム情報削除)' do
      it 'success (成功)' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        delete endpoint, headers: headers
        # expect(response.status).to eq 200
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      context 'failure (失敗)' do
        it 'frame has been deleted (フレーム削除済み)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          delete endpoint_frame_not_found_failure, headers: headers
          # expect(response.status).to eq 404
          assert_request_schema_confirm
          assert_response_schema_confirm(404)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
