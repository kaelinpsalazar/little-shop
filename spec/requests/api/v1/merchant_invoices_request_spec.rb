require 'rails_helper'

RSpec.describe Api::V1::MerchantsInvoicesController, type: :request do
  before(:each) do
    @merchant = create(:merchant)
    @customer = create(:customer)
    @invoice1 = create(:invoice, merchant: @merchant, customer: @customer, status: 'shipped')
    @invoice2 = create(:invoice, merchant: @merchant, customer: @customer, status: 'packaged')
  end

  describe 'GET /api/v1/merchants/:merchant_id/invoices' do
    it 'returns invoices with the correct status when the status is valid' do
      get "/api/v1/merchants/#{@merchant.id}/invoices?status=shipped"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:data].size).to eq(1)
      expect(json_response[:data][0][:attributes][:status]).to eq('shipped')
    end

    it 'returns an empty array when no invoices match when the status is valid' do
      get "/api/v1/merchants/#{@merchant.id}/invoices?status=returned"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:data]).to be_empty
    end

    it 'returns an error when the status is invalid' do
      get "/api/v1/merchants/#{@merchant.id}/invoices?status=invalid_status"

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:error]).to eq('Invalid status')
    end
  end
end