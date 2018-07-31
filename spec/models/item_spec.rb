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
end