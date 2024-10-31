class Api::V1::ItemsController < ApplicationController
  
  def index
    items = if params[:sorted] == 'price'
      Item.sorted_by_price
    else
      Item.all 
    end
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    begin
      item = Item.create!(item_params)
      render json: ItemSerializer.new(item), status: :created
    rescue ActiveRecord::RecordInvalid => exception
      render json: {
        errors: [
          {
            status: "422",
            message: "Error: All attributes must be included"
          }
        ]
      }, status: :unprocessable_entity
    end
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