class Api::V1::MerchantsController < ApplicationController    
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response
    rescue_from ActionController::ParameterMissing, with: :parameter_missing_response

    def index
        merchants = Merchant.fetch_merchants(params)
        render json: MerchantSerializer.new(merchants)
    end

    def show 
        merchant = Merchant.with_item_count.find(params[:id])
        render json: MerchantSerializer.new(merchant)
    end

    def create
        merchant = Merchant.create!(merchant_params)
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