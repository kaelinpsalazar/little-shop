require "rails_helper"

RSpec.describe "Items API", type: :request do
  before(:each) do
    @merchant = Merchant.create!(name: "Steve")
    create_list(:item, 4, merchant: @merchant)
  
      @fake_merchant = Merchant.create!(name: "Fake Merchant")
    end

    describe "Get all with #index" do
      it "can get all items" do
        get '/api/v1/items'

        expect(response).to be_successful
        expect(response).to have_http_status(:ok)

        items = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(items).to be_an(Array)
        expect(items.count).to eq(4)

      item = items[0]
      expect(item[:type]).to eq('item')
      expect(item[:id]).to be_an(String)
      expect(item).to have_key(:attributes)
      expect(item[:attributes][:description]).to be_an(String)
      expect(item[:attributes][:unit_price]).to be_an(Float)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
  

  describe "Create Item" do
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

  describe "Update Item" do
    it "can update an existing item" do
      item = Item.create(
        name: "socks",
        description: "keep feet warm",
        unit_price: 99.99,
        merchant_id: @merchant.id
      )

      item_params = {
        name: "Pants",
        description: "they keep legs warm",
        unit_price: 2.00,
        merchant_id: @merchant.id
      }

      headers = { "CONTENT_TYPE" => "application/json" }
      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({ item: item_params })

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

  it "can delete an item" do
    item = Item.create(
        name: "socks",
        description: "keep feet warm",
        unit_price: 99.99,
        merchant_id: @merchant.id
      )
      expect(Item.all.count).to eq(5)
      delete "/api/v1/items/#{item.id}"
      expect(response).to be_successful

      expect(Item.all.count).to eq(4)


      expect(Item.find_by(id: item.id)).to be_nil

  end

  it "can find the merchant information tied to a specific ID" do
    item = Item.create(
        name: "socks",
        description: "keep feet warm",
        unit_price: 99.99,
        merchant_id: @merchant.id
      )
    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
    expect(response).to have_http_status(200) 

    merchant_info = JSON.parse(response.body, symbolize_names: true)

  expect(merchant_info[:data]).to have_key(:id) 
  expect(merchant_info[:data][:attributes]).to have_key(:name) 
  expect(merchant_info[:data][:attributes][:name]).to eq(@merchant.name) 



  end
  
end