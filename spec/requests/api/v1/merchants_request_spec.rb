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

  describe "edits a merchant with #update" do
    it "can update an existing merchant" do
      id = Merchant.create(name: "Gnome Depot").id

      previous_name = Merchant.last.name
      merchant_params = { name: "Troll's"}
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate({merchant: merchant_params})

      merchant = Merchant.find_by(id: id)

      expect(response).to be_successful
      expect(merchant.name).to_not eq(previous_name)
      expect(merchant.name).to eq("Troll's")
    end
  end
end