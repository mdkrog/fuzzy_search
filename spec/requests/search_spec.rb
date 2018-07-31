# spec/requests/search_spec.rb
require 'rails_helper'

RSpec.describe 'Search API', type: :request do
  # initialize test data 
  let!(:items) { create_list(:item, 30) }

  # Test suite for GET /search
  describe 'GET /search' do
    it 'returns only 20 items' do
      get '/search' 
      # Note 'json' is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(20)
    end

    it 'returns status code 200' do
      get '/search' 
      expect(response).to have_http_status(200)
    end
  end
end