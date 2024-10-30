require 'rails_helper'

RSpec.describe "Fetch All Items" do
  before do
    @fake_merchant = Merchant.create!(name: "Fake Merchant")

    @item1 = Item.create!(
      name: "Item Nemo Facere",
      description: "Sunt eum id eius magni consequuntur delectus verit...",
      unit_price: 42.91,
      merchant: @fake_merchant
      )

    @item2 = Item.create!(
      name: "Item Expedita Aliquam",
      description: "Voluptate aut labore qui illum tempore eius. Corru...",
      unit_price: 687.23,
      merchant: @fake_merchant
      )
    @item3 = Item.create!(    
      name: "Item Provident At",
      description: "Numquam officiis reprehenderit eum ratione neque t...",
      unit_price: 159.25,
      merchant: @fake_merchant
      )
  end

  describe "get all with #index" do
    it "can get all items" do
      get '/api/v1/items'

      expect(response).to be_successful
      expect(response).to have_http_status(:ok)

      items = JSON.parse(response.body, symbolize_names:true)[:data]
      expect(items).to be_an(Array)      
      expect(items.count).to eq(3)

      item = items[0]
      expect(item[:type]).to eq('item')
      expect(item[:id].to_i).to eq(@item1.id)
      expect(item).to have_key(:attributes)
      expect(item[:attributes][:description]).to be_an(String)
      expect(item[:attributes][:unit_price]).to eq(42.91)
      expect(item[:attributes][:merchant_id]).to eq(@fake_merchant.id)      
    end
  end
end