# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Frames', type: :request do
  describe 'GET /api/v1/frames' do
    let(:endpoint) { '/api/v1/frames' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }

    before do
      create(:frame, :skip_validate, user: user, name: 'test00', tag_list: 'testA0', shooted_at: '2022/01/01')
      create(:frame, :skip_validate, user: user, name: 'test01', tag_list: 'testA1', shooted_at: '2022/01/01')
      create(:frame, :skip_validate, user: user, name: 'test12', tag_list: 'testB2', shooted_at: '2022/02/01')
      create(:frame, :skip_validate, user: user, name: 'test13', tag_list: 'testB3', shooted_at: '2022/02/01')
      create(:frame, :skip_validate, user: user, name: 'test24', tag_list: 'testC4', shooted_at: '2022/03/01')
      create(:frame, :skip_validate, user: user, name: 'test25', tag_list: 'testC5', shooted_at: '2022/03/01')
      create(:frame, :skip_validate, user: user, name: 'test36', tag_list: 'testC6', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test37', tag_list: 'testC7', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test48', tag_list: 'testD8', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test49', tag_list: 'testD9', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test50', tag_list: 'testE0', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test51', tag_list: 'testE1', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test62', tag_list: 'testF2', shooted_at: '2022/04/01')
      create(:frame, :skip_validate, user: user, name: 'test63', tag_list: 'testF3', shooted_at: '2022/04/01')
    end

    context 'get frame list (フレームリスト取得)' do
      context 'page=1 (1ページめ)' do
        it 'success (成功)' do
          get endpoint, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          expect(response.status).to eq 200
          json_data = json[:data]
          expect(json_data.size).to be 12
        end
      end

      context 'page=2 (2ページめ)' do
        it 'success (成功)' do
          get endpoint, params: { page: 2 }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          expect(response.status).to eq 200
          json_data = json[:data]
          expect(json_data.size).to be 2
        end
      end

      context 'q=test1(name)' do
        it 'success (成功)' do
          get endpoint, params: { q: 'test1' }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          expect(response.status).to eq 200
          json_data = json[:data]
          expect(json_data.size).to be 2
        end
      end

      context 'q=testA(tag name)' do
        it 'success (成功)' do
          get endpoint, params: { q: 'testA' }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          expect(response.status).to eq 200
          json_data = json[:data]
          expect(json_data.size).to be 2
        end
      end

      context 'q=2022/01/01(shooted_at)' do
        it 'success (成功)' do
          get endpoint, params: { q: '2022/01/01' }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          expect(response.status).to eq 200
          json_data = json[:data]
          expect(json_data.size).to be 2
        end
      end

      context 'q=Time.zone.today(created_at)' do
        it 'success (成功)' do
          get endpoint, params: { q: Time.zone.today.strftime('%Y/%m/%d') }, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          expect(response.status).to eq 200
          json_data = json[:data]
          expect(json_data.size).to be 12
        end
      end
    end
  end

  describe 'GET /api/v1/frames/:id' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}" }
    let(:endpoint_failure) { '/api/v1/frames/404' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }

    context 'get frame (フレーム情報取得)' do
      it 'success (成功)' do
        get endpoint, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        expect(response.status).to eq 200
        json_data = json[:data]
        expect(json_data).to have_type('frame')
        expect(json_data).to have_attribute('name')
      end

      it 'failure (失敗)' do
        get endpoint_failure, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        expect(response.status).to eq 404
      end
    end
  end

  describe 'GET /api/v1/frames/:frame_id/comments' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}/comments" }
    let(:endpoint_failure) { '/api/v1/frames/404/comments' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }

    before do
      create(:comment, body: 'comment01', frame_id: frame.id, user_id: user.id)
      create(:comment, body: 'comment02', frame_id: frame.id, user_id: user.id)
    end

    context 'get frame comment list (フレームのコメントリスト取得)' do
      it 'success (成功)' do
        get endpoint, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        expect(response.status).to eq 200
        json_data = json[:data]
        expect(json_data.size).to be 2
      end

      context 'failure (失敗)' do
        it 'frame_id doesn\'t exist' do
          get endpoint_failure, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          expect(response.status).to eq 404
        end
      end
    end
  end

  describe 'POST /api/v1/frames' do
    let(:endpoint) { '/api/v1/frames' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let(:file_1024) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
    }
    let(:file_over_capacity) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/over_capacity.jpg'), 'image/jpeg')
    }
    let(:file_different_mime_type) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/different_mime_type.txt'), 'text/plain')
    }

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    describe 'regist frame (フレーム情報登録)' do
      it 'success (成功)' do
        post endpoint,
             params: {
               frame: {
                 name: 'test_frame',
                 tag_list: 'test',
                 comment: 'testtest',
                 shooted_at: Time.zone.now,
                 file: file_1024
               }
             },
             headers: {
               'HTTP_ACCEPT_LANGUAGE': 'ja',
               'Authorization': "Bearer #{user.token}"
             }
        expect(response.status).to eq 200
        json_data = json[:data]
        expect(json_data).to have_type('frame')
        expect(json_data).to have_attribute('name')
      end

      context 'failure (失敗)' do
        it 'empty name (名前が空の場合)' do
          post endpoint,
               params: {
                 frame: {
                   name: '',
                   tag_list: 'test',
                   comment: 'testtest',
                   shooted_at: Time.zone.now,
                   file: file_1024
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'name exceeds 30 characters (名前が30文字を超える場合)' do
          post endpoint,
               params: {
                 frame: {
                   name: Faker::Alphanumeric.alpha(number: 31),
                   tag_list: 'test',
                   comment: 'testtest',
                   shooted_at: Time.zone.now,
                   file: file_1024
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'tag exceeds 10 characters (タグが10文字を超える場合)' do
          post endpoint,
               params: {
                 frame: {
                   name: Faker::Alphanumeric.alpha(number: 21),
                   tag_list: Faker::Alphanumeric.alpha(number: 11),
                   comment: 'testtest',
                   shooted_at: Time.zone.now,
                   file: file_1024
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:tag_list]).to be_present
        end

        it 'empty file (file が空の場合)' do
          post endpoint,
               params: {
                 frame: {
                   name: 'test_frame',
                   tag_list: 'test',
                   comment: 'testtest',
                   shooted_at: Time.zone.now
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end

        it 'file exceeds 5mb (fileが5MBを超えている場合)' do
          post endpoint,
               params: {
                 frame: {
                   name: 'test_frame',
                   tag_list: 'test',
                   comment: 'testtest',
                   shooted_at: Time.zone.now,
                   file: file_over_capacity
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end

        it 'file mime type is different (fileのmime typeが異なる場合)' do
          post endpoint,
               params: {
                 frame: {
                   name: 'test_frame',
                   tag_list: 'test',
                   comment: 'testtest',
                   shooted_at: Time.zone.now,
                   file: file_different_mime_type
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end
      end
    end
  end

  describe 'PUT /api/v1/frames/:id' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}" }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
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

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    describe 'update frame (フレーム情報更新)' do
      it 'success (成功)' do
        put endpoint,
            params: {
              frame: {
                name: 'test_frame',
                tag_list: 'test',
                comment: 'testtest',
                shooted_at: Time.zone.now,
                file: file_1024
              }
            },
            headers: {
              'HTTP_ACCEPT_LANGUAGE': 'ja',
              'Authorization': "Bearer #{user.token}"
            }
        expect(response.status).to eq 200
        json_data = json[:data]
        expect(json_data).to have_type('frame')
        expect(json_data).to have_attribute('name')
      end

      context 'failure (失敗)' do
        it 'empty name (名前が空の場合)' do
          put endpoint,
              params: {
                frame: {
                  name: '',
                  tag_list: 'test',
                  comment: 'testtest',
                  shooted_at: Time.zone.now,
                  file: file_1024
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'ja',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'name exceeds 30 characters (名前が30文字を超える場合)' do
          put endpoint,
              params: {
                frame: {
                  name: Faker::Alphanumeric.alpha(number: 31),
                  tag_list: 'test',
                  comment: 'testtest',
                  shooted_at: Time.zone.now,
                  file: file_1024
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'ja',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'tag exceeds 10 characters (タグが10文字を超える場合)' do
          put endpoint,
              params: {
                frame: {
                  name: Faker::Alphanumeric.alpha(number: 21),
                  tag_list: Faker::Alphanumeric.alpha(number: 11),
                  comment: 'testtest',
                  shooted_at: Time.zone.now,
                  file: file_1024
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'ja',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:tag_list]).to be_present
        end

        it 'empty file (file が空の場合)' do
          put endpoint,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  shooted_at: Time.zone.now
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'ja',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end

        it 'file exceeds 5mb (fileが5MBを超えている場合)' do
          put endpoint,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  shooted_at: Time.zone.now,
                  file: file_over_capacity
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'ja',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end

        it 'file mime type is different (fileのmime typeが異なる場合)' do
          put endpoint,
              params: {
                frame: {
                  name: 'test_frame',
                  tag_list: 'test',
                  comment: 'testtest',
                  shooted_at: Time.zone.now,
                  file: file_different_mime_type
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'ja',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:file]).to be_present
        end
      end
    end
  end

  describe 'DELETE /api/v1/frames/:id' do
    let(:endpoint) { "/api/v1/frames/#{frame.id}" }
    let(:endpoint_failure) { '/api/v1/frames/404' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }
    let!(:frame) { create(:frame, :skip_validate, user_id: user.id) }

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    context 'delete frame (フレーム情報削除)' do
      it 'success (成功)' do
        delete endpoint,
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
        expect(response.status).to eq 200
        json_data = json[:data]
        expect(json_data).to have_type('frame')
        expect(json_data).to have_attribute('name')
      end

      it 'failure (失敗)' do
        delete endpoint_failure,
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'ja',
                 'Authorization': "Bearer #{user.token}"
               }
        expect(response.status).to eq 404
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
