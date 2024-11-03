class Api::V1::ItemsMerchantController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    item = Item.find(params[:id])
    merchant = item.merchant
    render json: MerchantSerializer.new(merchant)
  end

  private
  def not_found_response(exception)
    render json: ErrorSerializer.format_error(exception, 404), status: :not_found
  end
end