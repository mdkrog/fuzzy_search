# spec/requests/search_spec.rb
require 'rails_helper'

RSpec.describe 'Search API', type: :request do
  # initialize test data 
  let!(:items) { create_list(:item, 30) }

  # Test suite for GET /search
  describe 'GET v1/search' do
    it 'returns only 20 items by default' do
      get '/v1/search?searchTerm=e'
      # Note 'json' is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(20)
    end

    it 'returns status code 200' do
      get '/v1/search' 
      expect(response).to have_http_status(200)
    end

    it 'should fail gracefully if no params provided' do
      get '/v1/search' 
      expect(json["error"]).to eq("No queriable fields provided")
    end

    it 'should return the only item within 1km radius of fat lama office' do
      create(:item, item_name: "Ancient Scroll", lat: 51.530973, lng: -0.040136) # within 1km of fat lama
      
      get '/v1/search?lat=51.529524&lng=-0.042223&radius=1'
 
      expect(json.first['item_name']).to eq("Ancient Scroll")
      expect(json.size).to eq(1)
    end

    it 'should return the only item called Ancient Scroll' do
      create(:item, item_name: "Ancient Scroll")
      
      get '/v1/search?searchTerm=Ancient%20Scroll'
 
      expect(json.first['item_name']).to eq("Ancient Scroll")
      expect(json.size).to eq(1)
    end

    it 'should return the only 3 items based on limit param' do      
      get '/v1/search?searchTerm=l&limit=3'
 
      expect(json.size).to eq(3)
    end
  end
end