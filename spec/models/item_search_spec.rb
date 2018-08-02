# spec/models/item_search_spec.rb
require 'rails_helper'

RSpec.describe ItemSearch, type: :model do
  describe "#call" do
    it "only calls item_name_search scope when search_term provided and no lng/lat" do
      allow(Item).to receive_messages(item_name_search: Item, nearby: Item)
      searcher = ItemSearch.new(search_term: "camera")
      
      searcher.call

      expect(Item).to have_received(:item_name_search)
      expect(Item).to_not have_received(:nearby)
    end

    it "only calls the nearby scope when lng, lat provided and no search term" do
      allow(Item).to receive_messages(item_name_search: Item, nearby: Item)
      searcher = ItemSearch.new(lat: 51.4803848, lng: -0.0937642008)
      
      searcher.call

      expect(Item).to_not have_received(:item_name_search)
      expect(Item).to have_received(:nearby)
    end

    it "calls nearby scope with radius when radius provided" do
      allow(Item).to receive_messages(item_name_search: Item, nearby: Item)
      searcher = ItemSearch.new(search_term: "camera", lat: 51.4803848, lng: -0.0937642008, radius: 5)
      
      searcher.call

      expect(Item).to have_received(:nearby).with(origin: [51.4803848, -0.0937642008], radius: 5)
    end

    it "does not call nearby scope when radius is provided but lat,lng are not" do
      allow(Item).to receive_messages(item_name_search: Item, nearby: Item)
      searcher = ItemSearch.new(search_term: "camera", radius: 5)
      
      searcher.call

      expect(Item).to_not have_received(:nearby)
    end

    it "does not call nearby scope when one of lat,lng are not provided" do
      allow(Item).to receive_messages(item_name_search: Item, nearby: Item)
      searcher = ItemSearch.new(search_term: "camera", lat: 51.4803848)
      
      searcher.call

      expect(Item).to_not have_received(:nearby)
    end

    it "calls item_name_search and nearby scopes when search_term and lng, lat provided" do
      allow(Item).to receive_messages(item_name_search: Item, nearby: Item)
      searcher = ItemSearch.new(search_term: "camera", lat: 51.4803848, lng: -0.0937642008)
      
      searcher.call

      expect(Item).to have_received(:item_name_search)
      expect(Item).to have_received(:nearby)
    end

    it "returns empty hash when no params provided" do
      allow(Item).to receive_messages(item_name_search: Item, nearby: Item)
      searcher = ItemSearch.new
      
      result = searcher.call

      expect(Item).to_not have_received(:item_name_search)
      expect(Item).to_not have_received(:nearby)
      expect(result).to eq({error: "No queriable fields provided"})
    end

    it "defaults to 20 when limit not an integer" do
      searcher = ItemSearch.new(limit: 'hello')
      
      expect(searcher.limit).to eq(20)
    end

    it "malformed lat and lng" do
      allow(Item).to receive_messages(item_name_search: Item, nearby: Item)
      searcher = ItemSearch.new(search_term: "e", lat: "hello", lng: "hello")
      
      searcher.call

      expect(Item).to_not have_received(:nearby)
    end

    it "it sorts results in from highest score to" do
      create_list(:item, 30)
      create(:item, item_name: "Sony Camera")
      create(:item, item_name: "Canon Camera")
      
      searcher = ItemSearch.new(search_term: "camera", lat: 51.4803848, lng: -0.0937642008)
      evaluator = searcher.relevance_evaluator
      
      items = searcher.call

      first_item_score = evaluator.score(items.first)
      last_item_score = evaluator.score(items.last)
      
      expect(first_item_score >= last_item_score).to be true
    end
  end
end