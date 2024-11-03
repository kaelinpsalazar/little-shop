class Api::V1::MerchantsController < ApplicationController

    def index
      merchants = Merchant.fetch_merchants(params)
      render json: MerchantSerializer.new(merchants)
    end

    def show 
      merchant = Merchant.with_item_count.find(params[:id])
        render json: MerchantSerializer.new(merchant)
    end

    def create
        merchant = Merchant.create(merchant_params)
        render json: MerchantSerializer.new(merchant)
    end

    def update
        render json: Merchant.update(params[:id], merchant_params)
    end
    
    def destroy
        render json: Merchant.delete(params[:id])
    end

    private

    def merchant_params
        params.require(:merchant).permit(:name)
    end

end