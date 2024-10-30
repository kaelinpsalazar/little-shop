class Api::V1::MerchantsController < ApplicationController
  def create
    merchant = Merchant.create!(merchant_params)
    render json: MerchantSerializer.new(merchant), status: :created
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end