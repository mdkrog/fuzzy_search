class V1::ItemsController < ApplicationController
  def index
    searcher = ItemSearch.new(search_term: params[:searchTerm], 
                              lat: params[:lat], 
                              lng: params[:lng], 
                              radius: params[:radius], 
                              limit: params[:limit])
    @items = searcher.call

    render json: @items
  end
end
