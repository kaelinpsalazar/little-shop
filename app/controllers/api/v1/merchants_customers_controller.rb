class Api::V1::MerchantsCustomersController < ApplicationController

  def index 
    merchant = Merchant.find(params[:merchant_id])
    customers = merchant.customers
    render json: CustomerSerializer.new(customers)
  end
end