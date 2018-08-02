# spec/models/item_spec.rb
require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "Fielda and Validations" do
    it { is_expected.to respond_to(:item_name) }
    it { is_expected.to respond_to(:lat) }
    it { is_expected.to respond_to(:lng) }
    it { is_expected.to respond_to(:item_url) }
    it { is_expected.to respond_to(:img_urls) }
    it { is_expected.to validate_presence_of(:item_name) }
  end

  describe "scopes" do  
    describe ".nearby" do
      before :each do
        create(:item, item_name: "Teddy Bear", lat: 51.516674, lng: -0.176933) # paddington station (5.86km)
        create(:item, item_name: "Camera", lat: 51.454513, lng: -2.587910) # bristol (109.8 km)
        create(:item, item_name: "Rosetta Stone", lat: 51.519413, lng: -0.126957) # british museum (3.7 km)
      end
      it "gets the items within a radius of 4 km" do
        fat_lama_office_loc = [51.529524, -0.042223]
        create(:item, item_name: "Rosetta Stone", lat: 51.529523, lng: -0.042224)
  
        items = Item.nearby(origin: fat_lama_office_loc, radius: 4)

        expect(items.count).to eq(1)
        expect(items.first.item_name).to eq("Rosetta Stone")
      end

      it "gets the closest items by distance if no radius supplied" do
        fat_lama_office_loc = [51.529524, -0.042223]
  
        items = Item.nearby(origin: fat_lama_office_loc).limit(10)

        expect(items.count).to eq(3)
        expect(items.first.item_name).to eq("Rosetta Stone")
        expect(items.last.item_name).to eq("Camera")
      end
    end

    describe ".fuzzy_search" do
      it "is case-insensitive when finding items" do  
        create(:item, item_name: "Camera")
        
        items = Item.fuzzy_search("camerA")

        expect(items.count).to eq(1)
        expect(items.first.item_name).to eq("Camera")
      end
      
      it "can partially match words" do
        create(:item, item_name: "Rosetta Stone")
        items = Item.fuzzy_search("one")
        expect(items.first.item_name).to eq("Rosetta Stone")
      end

      it "can match on hyphen based words" do
        create(:item, item_name: "Bat mobile")
        items = Item.fuzzy_search("bat-mobile")
        expect(items.first.item_name).to eq("Bat mobile")
      end

      it "excludes items that don't have any match" do
        create(:item, item_name: "Bat mobile")
        create(:item, item_name: "Light Saber")
        create(:item, item_name: "Camera Lighting Studio")

        items = Item.fuzzy_search("light saber")

        expect(items.count).to eq(2)
      end
    end
  end
end