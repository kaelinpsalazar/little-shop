class Api::V1::merchantsInvoicesController < ApplicationController

  def index 
    merchant = Merchant.find(params[merchant_id])
    invoices - merchant.invoices
    render json: InvoiceSerializer.new(invoices)
  end
end
