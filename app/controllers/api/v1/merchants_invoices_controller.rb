class Api::V1::MerchantsInvoicesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    merchant_id = params[:merchant_id]

    if params[:status].present?
      status = params[:status]

      if Invoice.valid_status?(status)
        invoices = Invoice.for_merchant_with_status(merchant_id, status)
        render json: InvoiceSerializer.new(invoices), status: :ok
      else
        render json: { error: 'Invalid status' }, status: :bad_request
      end
    else
      merchant = Merchant.find(merchant_id)
      render json: InvoiceSerializer.new(merchant.invoices), status: :ok
    end  
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.format_error(exception, 404), status: :not_found
  end
end