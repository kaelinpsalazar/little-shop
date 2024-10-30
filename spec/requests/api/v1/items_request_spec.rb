require "rails_helper"

describe Item do
  before(:each) do
    @merchant = Merchant.create!(name: "Steve")
    create_list(:item, 4, merchant: @merchant) 
  end

  
  describe "create item" do
    it "can create a new item" do
      new_item_params = {
        name: "Controller",
        description: "Play videogames",
        unit_price: 50.99,
        merchant_id: @merchant.id 
      }

      headers = { "CONTENT_TYPE" => "application/json" }

      expect(Item.all.count).to eq(4)

      post "/api/v1/items", headers: headers, params: JSON.generate(item: new_item_params)

      created_item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(created_item[:data][:attributes][:name]).to eq(new_item_params[:name])
      expect(created_item[:data][:attributes][:description]).to eq(new_item_params[:description])
      expect(created_item[:data][:attributes][:unit_price]).to eq(new_item_params[:unit_price])
      expect(created_item[:data][:attributes][:merchant_id]).to eq(new_item_params[:merchant_id])

      expect(Item.all.count).to eq(5)
    end
  end

  describe "update item" do
    it "can update an existing item" do
      item = Item.create(
        name: "socks",
        description: "keep feet warm",
        unit_price: 99.99,
        merchant_id: @merchant.id
      )

      item_params = {name: "Pants",
      description: "they keep legs warm",
      unit_price: 2.00,
      merchant_id: @merchant.id
      }

      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})

      changed_item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(changed_item[:data][:attributes][:name]).to_not eq(item.name)
      expect(changed_item[:data][:attributes][:description]).to_not eq(item.description)
      expect(changed_item[:data][:attributes][:unit_price]).to_not eq(item.unit_price)
      expect(changed_item[:data][:attributes][:name]).to eq("Pants")
      expect(changed_item[:data][:attributes][:description]).to eq("they keep legs warm")
      expect(changed_item[:data][:attributes][:unit_price]).to eq(2.00)

     end
    
  end
end