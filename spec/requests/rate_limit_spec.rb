require 'rails_helper'

RSpec.describe Rack::Attack, type: :request do
  include Rack::Test::Methods

  it "throttle excessive requests by IP address" do
    (300 + 2).times do
      get '/v1/search'
    end

    expect(last_response.status).to eq 429

    # clean up
    avoid_test_overlaps_in_cache
  end

  def avoid_test_overlaps_in_cache
    Rails.cache.clear
  end
end