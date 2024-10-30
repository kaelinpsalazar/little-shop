class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end
  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end
  def update
    item = Item.find(params[:id])
    if item.update!(item_params)  
      render json: ItemSerializer.new(item), status: :ok
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
  

end