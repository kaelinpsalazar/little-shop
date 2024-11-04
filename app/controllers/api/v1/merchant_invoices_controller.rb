class Api::V1::merchantsInvoicesController < ApplicationController

  def index 
    merchant_id = params[:merchant_id]
    status = params[:status]

    invoices = Invoice.for_merchant_with_status(merchant_id, status)
    render json: InvoiceSerializer.new(invoices)
  end
end
