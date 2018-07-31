class SearchItemsController < ApplicationController
  def index
    @items = Item.all.limit(20)
    json_response(@items)
  end
end
