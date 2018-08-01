class V1::ItemsController < ApplicationController
  def index
    @items = Item.nearby(origin: [params[:lat], params[:lng]]).limit(20).fuzzy_search(params[:searchTerm]).limit(20)
    render json: @items
  end
end
