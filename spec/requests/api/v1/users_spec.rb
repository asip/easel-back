# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Users', type: :request do
  describe 'GET /api/v1/users/:id' do
    let(:endpoint) { "/api/v1/users/#{user.id}" }
    let_it_be(:endpoint_failure) { '/api/v1/users/404' }
    let_it_be(:user) { create(:user, password: 'testtest') }

    context 'get user (ユーザー情報取得)' do
      it 'success (成功)' do
        get endpoint, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        # expect(response.status).to eq(200)
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      it 'failure (失敗)' do
        get endpoint_failure, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        # expect(response.status).to eq(404)
        assert_request_schema_confirm
        assert_response_schema_confirm(404)
      end
    end
  end

  describe 'GET /api/v1/users/:user_id/frames' do
    let(:endpoint) { "/api/v1/users/#{user.id}/frames" }
    let_it_be(:endpoint_failure) { '/api/v1/users/404/frames' }
    let_it_be(:user) { create(:user, password: 'testtest') }

    before_all do
      create(:frame, :skip_validate, name: 'test00', tag_list: 'testA0', shooted_at: '2022/01/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test01', tag_list: 'testA1', shooted_at: '2022/01/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test12', tag_list: 'testB2', shooted_at: '2022/02/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test13', tag_list: 'testB3', shooted_at: '2022/02/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test24', tag_list: 'testC4', shooted_at: '2022/03/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test25', tag_list: 'testC5', shooted_at: '2022/03/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test36', tag_list: 'testC6', shooted_at: '2022/04/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test37', tag_list: 'testC7', shooted_at: '2022/04/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test48', tag_list: 'testD8', shooted_at: '2022/05/01', user_id: user.id)
      create(:frame, :skip_validate, name: 'test49', tag_list: 'testD9', shooted_at: '2022/05/01', user_id: user.id)
      # create(:frame, :skip_validate, name: 'test50', tag_list: 'testE0', shooted_at: '2022/06/01', user_id: user.id)
      # create(:frame, :skip_validate, name: 'test51', tag_list: 'testE1', shooted_at: '2022/07/01', user_id: user.id)
      # create(:frame, :skip_validate, name: 'test62', tag_list: 'testF2', shooted_at: '2022/07/01', user_id: user.id)
      # create(:frame, :skip_validate, name: 'test63', tag_list: 'testF3', shooted_at: '2022/07/01', user_id: user.id)
    end

    context 'get user frame list (ユーザーのフレームリスト取得)' do
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

      it 'failure (失敗)' do
        get endpoint_failure, headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        # expect(response.status).to eq 404
        assert_request_schema_confirm
        assert_response_schema_confirm(404)
      end
    end
  end

  describe 'POST /api/v1/users' do
    let_it_be(:endpoint) { '/api/v1/users' }
    let(:file_1024) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
    }
    let(:file_over_capacity) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/over_capacity.jpg'), 'image/jpeg')
    }
    let(:file_different_mime_type) {
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/different_mime_type.txt'), 'text/plain')
    }

    context 'regist user (ユーザー情報登録)' do
      context 'success (成功)' do
        it 'without image' do
          post endpoint,
               params: {
                 user: {
                   name: 'test_user01',
                   email: 'test@test.jp',
                   password: 'testtest',
                   password_confirmation: 'testtest',
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(200)
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          # json_data = json
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
                 image: file_1024,
                 time_zone: 'Asia/Tokyo'
               }
             },
             headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
        # expect(response.status).to eq(200)
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      context 'failure (失敗)' do
        it 'empty name (名前が空の場合)' do
          post endpoint,
               params: {
                 user: {
                   name: '',
                   email: 'test@test.jp',
                   password: 'testtest',
                   password_confirmation: 'testtest',
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
        assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'name exceeds 40 characters (名前が40文字を超える場合)' do
          post endpoint,
               params: {
                 user: {
                   name: Faker::Alphanumeric.alpha(number: 41),
                   email: 'test@test.jp',
                   password: 'testtest',
                   password_confirmation: 'testtest',
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'empty email (emailが空の場合)' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: '',
                   password: 'testtest',
                   password_confirmation: 'testtest',
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:email]).to be_present
        end

        it 'invalid email' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: 'invalidemail',
                   password: 'testtest',
                   password_confirmation: 'testtest',
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:email]).to be_present
        end

        it 'password is less than 6 characters (パスワードが6文字に満たない場合)' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: 'test@test.jp',
                   password: 'te',
                   password_confirmation: 'te',
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:password]).to be_present
        end

        it 'password and passoword_confirmation don\'t match (パスワードとパスワード(確認)が一致しない場合)' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: 'test@test.jp',
                   password: 'testtest',
                   password_confirmation: 'testtesttest',
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:password]).to be_nil
          expect(json_data[:errors][:password_confirmation]).to be_present
        end

        it 'password and passoword_confirmation are empty (パスワードとパスワード(確認)が空の場合)' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: 'test@test.jp',
                   password: '',
                   password_confirmation: '',
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:password]).to be_present
        end

        it 'image exceeds 5mb (イメージが5MBを超えている場合)' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: 'test@test.jp',
                   password: 'testtest',
                   password_confirmation: 'testtest',
                   image: file_over_capacity,
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:image]).to be_present
        end

        it 'image mime type is different (imageのmime typeが異なる場合)' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: 'test@test.jp',
                   password: 'testtest',
                   password_confirmation: 'testtest',
                   image: file_different_mime_type,
                   time_zone: 'Asia/Tokyo'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'ja' }
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:image]).to be_present
        end
      end
    end
  end

  describe 'PUT /api/v1/account/profile' do
    let_it_be(:endpoint) { '/api/v1/account/profile' }
    let!(:user) { create(:user, password: 'testtest') }
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

    context 'update user (ユーザー情報更新)' do
      context 'success (成功)' do
        it 'without image' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  name: 'test_user01',
                  email: 'test@test.jp',
                  time_zone: 'Asia/Tokyo'
                }
              },
              headers: headers
          # expect(response.status).to eq(200)
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          # json_data = json
        end
      end

      it 'with image' do
        headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
        put endpoint,
            params: {
              user: {
                name: 'test_user01',
                email: 'test@test.jp',
                image: file_1024,
                time_zone: 'Asia/Tokyo'
              }
            },
            headers: headers
        # expect(response.status).to eq(200)
        assert_request_schema_confirm
        assert_response_schema_confirm(200)
        # json_data = json
      end

      context 'failure (失敗)' do
        it 'empty name (名前が空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  name: '',
                  email: 'test@test.jp',
                  time_zone: 'Asia/Tokyo'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'name exceeds 40 characters (名前が40文字を超える場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  name: Faker::Alphanumeric.alpha(number: 41),
                  email: 'test@test.jp',
                  time_zone: 'Asia/Tokyo'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'empty email (emailが空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: '',
                  time_zone: 'Asia/Tokyo'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:email]).to be_present
        end

        it 'invalid email' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: 'invalidemail',
                  time_zone: 'Asia/Tokyo'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:email]).to be_present
        end

        it 'image exceeds 5mb (イメージが5MBを超えている場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: 'test@test.jp',
                  image: file_over_capacity,
                  time_zone: 'Asia/Tokyo'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:image]).to be_present
        end

        it 'image mime type is different (imageのmime typeが異なる場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: 'test@test.jp',
                  image: file_different_mime_type,
                  time_zone: 'Asia/Tokyo'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:image]).to be_present
        end
      end
    end
  end

  describe 'PUT /api/v1/account/password' do
    let_it_be(:endpoint) { '/api/v1/account/password' }
    let!(:user) { create(:user, password: 'testtest') }
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

    context 'update password (パスワード更新)' do
      context 'success (成功)' do
        it 'password and passoword_confirmation are empty (パスワードとパスワード(確認)が空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  current_password: "testtest",
                  password: '',
                  password_confirmation: ''
                }
              },
              headers: headers
          # expect(response.status).to eq(200)
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          # json_data = json
        end
      end

      context 'failure (失敗)' do
        it 'empty current password (現在のパスワードが空の場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  current_password: "",
                  password: 'te',
                  password_confirmation: 'te'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:password]).to be_present
        end
        it 'invalid current password (現在のパスワードが間違っている場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  current_password: "testtest_error",
                  password: 'te',
                  password_confirmation: 'te'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:current_password]).to be_present
        end

        it 'password is less than 6 characters (パスワードが6文字に満たない場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  current_password: "testtest",
                  password: 'te',
                  password_confirmation: 'te'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:password]).to be_present
        end

        it 'password and passoword_confirmation don\'t match (パスワードとパスワード(確認)が一致しない場合)' do
          headers.merge!({ 'HTTP_ACCEPT_LANGUAGE': 'ja' })
          put endpoint,
              params: {
                user: {
                  current_password: "testtest",
                  password: 'testtest',
                  password_confirmation: 'testtesttest'
                }
              },
              headers: headers
          # expect(response.status).to eq(422)
          assert_request_schema_confirm
          assert_response_schema_confirm(422)
          json_data = json
          expect(json_data[:errors][:password]).to be_nil
          expect(json_data[:errors][:password_confirmation]).to be_present
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
