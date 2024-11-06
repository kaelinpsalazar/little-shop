class Api::V1::MerchantsController < ApplicationController    
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response
    rescue_from ActionController::ParameterMissing, with: :parameter_missing_response
  
    def update
      merchant = Merchant.find(params[:id])

      if merchant.update(merchant_params)
        render json: MerchantSerializer.new(merchant), status: :ok
      else
        render json: { errors: merchant.errors.full_messages }, status: :unprocessable_entity
      end
  end

    def show 
        merchant = Merchant.with_item_count.find(params[:id])
        render json: MerchantSerializer.new(merchant)
    end

    def create
        merchant = Merchant.create!(merchant_params)
        render json: MerchantSerializer.new(merchant), status: :created
    end

    def update
        render json: Merchant.update(params[:id], merchant_params)
    end
    
    def destroy
        merchant = Merchant.find(params[:id])
        merchant.destroy
        render json: { message: "Merchant deleted successfully" }, status: :no_content
    end

    def find
        if params[:name].present?
            merchant = Merchant.find_merchant_by_name(params)
            if merchant
                without_item_count = MerchantSerializer.new(merchant).serializable_hash                
                without_item_count[:data][:attributes].delete(:item_count)
                render json: without_item_count
            else
                render json: { data: {} }, status: :not_found
            end
        else
            render json: { error: "Invalid search term" }, status: :bad_request
        end
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