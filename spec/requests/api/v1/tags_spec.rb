# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Tags', type: :request do
  describe 'GET /api/v1/tags/search' do
    let_it_be(:endpoint) { '/api/v1/tags/search' }
    let!(:headers) { { 'HTTP_ACCEPT_LANGUAGE': 'ja' } }

    before_all do
      create(:application_tag, name: 'a00001')
      create(:application_tag, name: 'aaa001')
      create(:application_tag, name: 'aab001')
      create(:application_tag, name: 'aac001')
      create(:application_tag, name: 'aad001')
      create(:application_tag, name: 'aba001')
      create(:application_tag, name: 'abb001')
    end

    context 'get tag name list (タグ名リスト取得)' do
      context 'fewer than 5 search results (検索結果が5件ない場合)' do
        it 'success (成功)' do
          get endpoint, params: { q: "aa" }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:tags]
          expect(json_data.size).to be 4
        end
      end

      context '5 or more search results (検索結果が5件以上ある場合)' do
        it 'success (成功)' do
          get endpoint, params: { q: "a" }, headers: headers
          # expect(response.status).to eq 200
          assert_request_schema_confirm
          assert_response_schema_confirm(200)
          json_data = json[:tags]
          expect(json_data.size).to be 5
        end
      end
    end
  end
end
