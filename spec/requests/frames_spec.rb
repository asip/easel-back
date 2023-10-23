# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
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

  describe 'POST /api/v1/frames' do
    let(:endpoint) { '/api/v1/frames' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }

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
                 file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
               }
             },
             headers: {
               'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                   file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
                 'Authorization': "Bearer #{user.token}"
               }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'name exceeds 20 characters (名前が20文字を超える場合)' do
          post endpoint,
               params: {
                 frame: {
                   name: Faker::Alphanumeric.alpha(number: 21),
                   tag_list: 'test',
                   comment: 'testtest',
                   shooted_at: Time.zone.now,
                   file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                   file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                   file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/over_capacity.jpg'),
                                                      'image/jpeg')
                 }
               },
               headers: {
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
              }
            },
            headers: {
              'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                  file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq 200
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'name exceeds 20 characters (名前が20文字を超える場合)' do
          put endpoint,
              params: {
                frame: {
                  name: Faker::Alphanumeric.alpha(number: 21),
                  tag_list: 'test',
                  comment: 'testtest',
                  shooted_at: Time.zone.now,
                  file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                  file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                  file: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/over_capacity.jpg'),
                                                     'image/jpeg')
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
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
                 'HTTP_ACCEPT_LANGUAGE': 'jp',
                 'Authorization': "Bearer #{user.token}"
               }
        expect(response.status).to eq 404
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
