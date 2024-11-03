class Api::V1::MerchantsCustomersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response  

  def index 
    merchant = Merchant.find(params[:merchant_id])
    customers = merchant.customers
    render json: CustomerSerializer.new(customers)
  end

  private
  def not_found_response(exception)
    render json: ErrorSerializer.format_error(exception, 404), status: :not_found
  end
end