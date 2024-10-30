class Api::V1::MerchantsController < ApplicationController
    
    def show 
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
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