class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response
  rescue_from ActionController::ParameterMissing, with: :parameter_missing_response

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

  def find_all
    if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render json: { error: "Cannot search by both name and price" }, status: :bad_request
      return
    end

    if params[:min_price].present? || params[:max_price].present?
      items = Item.find_items_by_price(params.slice(:min_price, :max_price))    
    elsif params[:name].present?
      items = Item.find_items_by_name(params[:name])
    else
      render json: { error: "No search parameters provided" }, status: :bad_request
      return
    end
  
    if items.empty?
      render json: { error: "No items found" }, status: :not_found
    else
      render json: ItemSerializer.new(items), status: :ok
    end
  end
  
  

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.format_error(exception, 404), status: :not_found
  end

  def unprocessable_entity_response(exception)
    render json: ErrorSerializer.format_error(exception, 422), status: :unprocessable_entity
  end
  
  def parameter_missing_response(exception)
    render json: ErrorSerializer.format_error(exception, 400), status: :bad_request
  end 
end