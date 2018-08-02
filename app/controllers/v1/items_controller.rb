class V1::ItemsController < ApplicationController
  def index
    searcher = ItemSearch.new(search_term: params[:searchTerm], 
                              lat: params[:lat], 
                              lng: params[:lng], 
                              radius: params[:radius], 
                              limit: params[:limit])
    @items = searcher.call

    expires_in 3.minutes, public: true
    render json: @items
  end
end
