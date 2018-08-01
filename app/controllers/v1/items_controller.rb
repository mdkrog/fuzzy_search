class V1::ItemsController < ApplicationController
  def index
    @items = Item.all.limit(20)
    render json: @items
  end
end
