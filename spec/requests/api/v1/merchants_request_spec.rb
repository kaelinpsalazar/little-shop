require "rails_helper"

describe Merchant do
  before (:each) do
    create_list(:merchant, 4)
  end
  describe "create merchant" do
    it "can create a new merchant" do
      new_merchant_params = {
      name: "kaelin"
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      expect(Merchant.all.count).to eq(4)

      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant:new_merchant_params)

      created_merchant = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(created_merchant[:data][:attributes][:name]).to eq(new_merchant_params[:name])
      expect(Merchant.all.count).to eq(5)

    end
  end
end