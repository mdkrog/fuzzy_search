# spec/models/relevance_evaluator_spec.rb
require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "Calculate Score" do
    it "scores an item somewhere between 0 and 10" do
      fat_lama_office_loc = [51.529524, -0.042223]
      item = build(:item, item_name: "Rosetta Stone", lat: 51.519413, lng: -0.126957) # british museum (within 4km)
      
      evaluator = RelevanceEvaluator.new("Rolling Stones EP", fat_lama_office_loc)
      score = evaluator.score(item)

      expect(score < 10 && score > 0).to be true
    end

    it "scores 20/20 on perfect match (exact terms and within 1km)" do
      fat_lama_office_loc = [51.529524, -0.042223]
      item = build(:item, item_name: "Rosetta Stone", lat: 51.530973, lng: -0.040136) # st barnabas church (within 1km)
      
      evaluator = RelevanceEvaluator.new("Rosetta Stone", fat_lama_office_loc)
      score = evaluator.score(item)
      
      expect(score).to eq(10)
    end

    it "scores close to 0/10 on terrible match" do
      fat_lama_office_loc = [51.529524, -0.042223]
      item = build(:item, item_name: "Apple", lat: 51.454513, lng: -2.587910) # bristol
      
      evaluator = RelevanceEvaluator.new("N", fat_lama_office_loc)
      score = evaluator.score(item)
      
      expect(score > 0 && score < 1).to be true
    end
  end
end