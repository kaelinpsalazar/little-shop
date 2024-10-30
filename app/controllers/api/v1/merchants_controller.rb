class Api::V1::MerchantsController < ApplicationController
    
    def show 
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end

    private

    def poster_prams
        params.require(:merchant).permit(:name)
    end

end