# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Users', type: :request do
  describe 'GET /api/v1/users/:id' do
    let(:endpoint) { "/api/v1/users/#{user.id}" }
    let(:endpoint_failure) { '/api/v1/users/404' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }

    context 'get user (ユーザー情報取得)' do
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

      context 'failure (失敗)' do
        it 'empty name (名前が空の場合)' do
          post endpoint,
               params: {
                 user: {
                   name: '',
                   email: 'test@test.jp',
                   password: 'testtest',
                   password_confirmation: 'testtest'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
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
                   password_confirmation: 'testtest'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
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
                   password_confirmation: 'testtest'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
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
                   password_confirmation: 'testtest'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:email]).to be_present
        end

        it 'email exceeds 319 characters (emailが319文字を超える場合)' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: "#{Faker::Alphanumeric.alpha(number: 315)}@test.jp",
                   password: 'testtest',
                   password_confirmation: 'testtest'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:email]).to be_present
        end

        it 'password is less than 3 characters (パスワードが３文字に満たない場合)' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: 'test@test.jp',
                   password: 'te',
                   password_confirmation: 'te'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
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
                   password_confirmation: 'testtesttest'
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
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
                   password_confirmation: ''
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:password]).to be_present
          expect(json_data[:errors][:password_confirmation]).to be_present
        end

        it 'image exceeds 5mb (イメージが5MBを超えている場合)' do
          post endpoint,
               params: {
                 user: {
                   name: 'test',
                   email: 'test@test.jp',
                   password: 'testtest',
                   password_confirmation: 'testtest',
                   image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/over_capacity.jpg'),
                                                       'image/jpeg')
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
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
                   image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/different_mime_type.txt'),
                                                       'text/plain')
                 }
               },
               headers: { 'HTTP_ACCEPT_LANGUAGE': 'jp' }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:image]).to be_present
        end
      end
    end
  end

  describe 'PUT /api/v1/profile' do
    let(:endpoint) { '/api/v1/profile' }
    let!(:user) { create(:user, password: 'testtest', password_confirmation: 'testtest') }

    before do
      user.assign_token(User.issue_token(id: user.id, email: user.email))
    end

    context 'update user (ユーザー情報更新)' do
      context 'success (成功)' do
        it 'password and passoword_confirmation are empty (パスワードとパスワード(確認)が空の場合)' do
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: 'test@test.jp',
                  password: '',
                  password_confirmation: ''
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json[:data]
          expect(json_data).to have_type('user')
          expect(json_data).to have_attribute('name')
          expect(json_data).to have_attribute('email')
        end

        it 'without image' do
          put endpoint,
              params: {
                user: {
                  name: 'test_user01',
                  email: 'test@test.jp',
                  password: 'testtest',
                  password_confirmation: 'testtest'
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json[:data]
          expect(json_data).to have_type('user')
          expect(json_data).to have_attribute('name')
          expect(json_data).to have_attribute('email')
        end
      end

      it 'with image' do
        put endpoint,
            params: {
              user: {
                name: 'test_user01',
                email: 'test@test.jp',
                password: 'testtest',
                password_confirmation: 'testtest',
                image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/1024x1024.png'), 'image/png')
              }
            },
            headers: {
              'HTTP_ACCEPT_LANGUAGE': 'jp',
              'Authorization': "Bearer #{user.token}"
            }
        expect(response.status).to eq(200)
        json_data = json[:data]
        expect(json_data).to have_type('user')
        expect(json_data).to have_attribute('name')
        expect(json_data).to have_attribute('email')
      end

      context 'failure (失敗)' do
        it 'empty name (名前が空の場合)' do
          put endpoint,
              params: {
                user: {
                  name: '',
                  email: 'test@test.jp',
                  password: 'testtest',
                  password_confirmation: 'testtest'
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'name exceeds 40 characters (名前が40文字を超える場合)' do
          put endpoint,
              params: {
                user: {
                  name: Faker::Alphanumeric.alpha(number: 41),
                  email: 'test@test.jp',
                  password: 'testtest',
                  password_confirmation: 'testtest'
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:name]).to be_present
        end

        it 'empty email (emailが空の場合)' do
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: '',
                  password: 'testtest',
                  password_confirmation: 'testtest'
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:email]).to be_present
        end

        it 'invalid email' do
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: 'invalidemail',
                  password: 'testtest',
                  password_confirmation: 'testtest'
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:email]).to be_present
        end

        it 'email exceeds 319 characters (emailが319文字を超える場合)' do
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: "#{Faker::Alphanumeric.alpha(number: 315)}@test.jp",
                  password: 'testtest',
                  password_confirmation: 'testtest'
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:email]).to be_present
        end

        it 'password is less than 3 characters (パスワードが３文字に満たない場合)' do
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: 'test@test.jp',
                  password: 'te',
                  password_confirmation: 'te'
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:password]).to be_present
        end

        it 'password and passoword_confirmation don\'t match (パスワードとパスワード(確認)が一致しない場合)' do
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: 'test@test.jp',
                  password: 'testtest',
                  password_confirmation: 'testtesttest'
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:password]).to be_nil
          expect(json_data[:errors][:password_confirmation]).to be_present
        end

        it 'image exceeds 5mb (イメージが5MBを超えている場合)' do
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: 'test@test.jp',
                  password: 'testtest',
                  password_confirmation: 'testtest',
                  image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/over_capacity.jpg'),
                                                      'image/jpeg')
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:image]).to be_present
        end

        it 'image mime type is different (imageのmime typeが異なる場合)' do
          put endpoint,
              params: {
                user: {
                  name: 'test',
                  email: 'test@test.jp',
                  password: 'testtest',
                  password_confirmation: 'testtest',
                  image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/different_mime_type.txt'),
                                                      'text/plain')
                }
              },
              headers: {
                'HTTP_ACCEPT_LANGUAGE': 'jp',
                'Authorization': "Bearer #{user.token}"
              }
          expect(response.status).to eq(200)
          json_data = json
          expect(json_data[:errors][:image]).to be_present
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
