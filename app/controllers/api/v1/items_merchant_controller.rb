class Api::V1::ItemsMerchantController < ApplicationController
  def index

    item = Item.find(params[:id])
    merchant = item.merchant
    render json: MerchantSerializer.new(merchant)
  end

end

