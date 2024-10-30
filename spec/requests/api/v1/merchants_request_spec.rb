require "rails_helper"

RSpec.describe "Mechant", type: :request do
  before(:each) do 
    @merchant1 = Merchant.create!(name: "Gnome Depot")
    @merchant2 = Merchant.create!(name: "Bloodbath and Beyond")
    @merchant3 = Merchant.create!(name: "The Philosopher's Scone")
  end

  describe "make a new merchant with #create" do
    it "creates a new merchant" do
      merchant_attributes = {name: "Gnome Depot"}

      post "/api/v1/merchants#create", params: {merchant: merchant_attributes}

      merchant = JSON.parse(response.body, symbolize_names: true)[:data].first

      expect(merchant[:attributes][:name]).to eq(merchant_attributes[:name])
    end
  end

end