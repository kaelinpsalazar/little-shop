require "rails_helper"

RSpec.describe "Items API", type: :request do
  
  before(:each) do
    Item.destroy_all
    @merchant = Merchant.create!(name: "Steve")
    @items = create_list(:item, 4, merchant: @merchant)
  
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

    it "can get all items sorted by price" do 
      get '/api/v1/items?sorted=price'
      
      expect(response).to be_successful 
      expect(response).to have_http_status(:ok) 

      items = JSON.parse(response.body, symbolize_names: true)[:data] 

      expect(items).to be_an(Array) 
      expect(items.count).to eq(4) 

      prices = items.map { |item| item[:attributes][:unit_price] } 
      expect(prices).to eq(prices.sort)
    end
  end

  describe "Show item" do
    it "can show an individual item" do
      item = Item.create(
        name: "socks",
        description: "keep feet warm",
        unit_price: 99.99,
        merchant_id: @merchant.id
      )
      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      
      item = JSON.parse(response.body, symbolize_names:true)[:data]

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

  it "can find the merchant information tied to a specific merchant ID" do
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

  describe "sad paths" do
    it "will return an error if all endpoints are not included" do
      item_params = {
        name: "",
        description: "",
        unit_price: nil,
        merchant_id: @merchant.id
      }

      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(422)


      created_item = JSON.parse(response.body, symbolize_names: true)

      expect(created_item[:errors]).to be_a(Array)
      expect(created_item[:errors].first[:status]).to eq("422")
      expect(created_item[:errors].first[:title]).to eq("Unprocessable Entity")
      expect(created_item[:errors].first[:detail]).to eq("Validation failed: Name can't be blank, Unit price can't be blank, Description can't be blank")
    end

    it "returns a 404 status with error message when item doesn't exist" do
      get "/api/v1/items/219058"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      get_item = JSON.parse(response.body, symbolize_names: true)

      expect(get_item[:errors]).to be_a(Array)
      expect(get_item[:errors].first[:status]).to eq("404")
      expect(get_item[:errors].first[:title]).to eq("Resource Not Found")
      expect(get_item[:errors].first[:detail]).to eq("Couldn't find Item with 'id'=219058")
    end

    it "returns a 400 status with error message when required params are missing" do
      item_params = {        
      }

      headers = { "CONTENT_TYPE" => "application/json" }      
    
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    
      missing_params = JSON.parse(response.body, symbolize_names: true)
    
      expect(missing_params[:errors]).to be_a(Array)
      expect(missing_params[:errors].first[:status]).to eq("400")
      expect(missing_params[:errors].first[:title]).to eq("Bad Request")
      expect(missing_params[:errors].first[:detail]).to eq("param is missing or the value is empty: item")
    end

    it "will return an error if given an empty object" do
      item_params = {        
      }

      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v1/items/4", headers: headers, params: JSON.generate(item: item_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)


      created_item = JSON.parse(response.body, symbolize_names: true)

      expect(created_item[:errors]).to be_a(Array)
      expect(created_item[:errors].first[:status]).to eq("404")
      expect(created_item[:errors].first[:title]).to eq("Resource Not Found")
      expect(created_item[:errors].first[:detail]).to eq("Couldn't find Item with 'id'=4")
    end

    it "returns a 404 error if the item does not exist" do
      get "/api/v1/items/999999/merchant"
    
      expect(response).to have_http_status(:not_found)
    
      error_response = JSON.parse(response.body, symbolize_names: true)
    
      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_an(Array)
    
      error = error_response[:errors].first
      expect(error[:status]).to eq("404")
      expect(error[:title]).to eq("Resource Not Found")
      expect(error[:detail]).to eq("Couldn't find Item with 'id'=999999")
    end

    it 'returns "Error" for any other status' do
      expect(ErrorSerializer.error_title(408)).to eq("Error")
      expect(ErrorSerializer.error_title(403)).to eq("Error")
      expect(ErrorSerializer.error_title(401)).to eq("Error")
    end
  end

  describe 'find all items based on filtering' do
    before(:each) do
      @item1 = create(:item, name: 'airbuds', unit_price: 75.00, merchant: @merchant)
      @item2 = create(:item, name: 'hydroflask', unit_price: 20.00, merchant: @merchant)
      @item3 = create(:item, name: 'airpump', unit_price: 55.00, merchant: @merchant)
    end

    it 'returns all items that match a minimum price parameter using#find_items_by_unit_price' do
      get "/api/v1/items/find_all", params: { min_price: 50.00 }

      expect(response).to be_successful
    
      items = JSON.parse(response.body, symbolize_names: true)[:data]
    
      expect(items).to include(
        include(
          attributes: include(name: "airbuds", unit_price: 75.00)
        ),
        include(
          attributes: include(name: "airpump", unit_price: 55.00)
        )
      )  
    end

    it 'returns all items that match a maximum price parameter using #find_items_by_unit_price' do
      get '/api/v1/items/find_all', params: { max_price: 70.00 }

      expect(response).to be_successful
    
      items = JSON.parse(response.body, symbolize_names: true)[:data]
    
      expect(items).to include(
        include(
          attributes: include(name: "hydroflask", unit_price: 20.00)
        ),
        include(
          attributes: include(name: "airpump", unit_price: 55.00)
        )
      )  
    end

    it 'returns all items that match a maximum and minimum price parameter using #find_items_by_unit_price' do
    get '/api/v1/items/find_all', params: { min_price: 30.00, max_price: 70.00 }

    expect(response).to be_successful
  
    items = JSON.parse(response.body, symbolize_names: true)[:data]
  
    expect(items).to include(
      include(
        attributes: include(name: "airpump", unit_price: 55.00)
      )
    )  
  end

    it 'returns all items that match a name using #find_items_by_name' do
      get '/api/v1/items/find_all', params: { name: 'air' }

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items).to include(
        include(
          attributes: include(name: "airbuds", unit_price: 75.00)
        ),
        include(
          attributes: include(name: "airpump", unit_price: 55.00)
        )
      )
    end

    describe "reutrns a single item with name params using #find" do
      it "returns a single item matching the search criteria" do
        get "/api/v1/items/find", params: { name: "airpump" }
        expect(response).to be_successful
        item = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(item[:attributes][:name]).to eq("airpump")
      end
    end
  

    describe "sad paths find all items" do
      before(:each) do
        @merchant = create(:merchant)
        @item1 = create(:item, name: 'airbuds', unit_price: 75.00, merchant: @merchant)
        @item2 = create(:item, name: 'hydroflask', unit_price: 20.00, merchant: @merchant)
        @item3 = create(:item, name: 'airpump', unit_price: 55.00, merchant: @merchant)
      end
      it 'find all items on partial name' do
    
        get '/api/v1/items/find_all/?name=air'
    
        expect(response).to be_successful
    
        
        items = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(items).to be_an(Array)
        items.each do |item|
          expect(item[:attributes][:name]).to include("air")
        
        end
      end

      it "returns a 400 error when fragment is empty" do
        get '/api/v1/items/find_all/?name=air'
    
        expect(response).to be_successful
    
        
        items = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(items).to be_an(Array)
        items.each do |item|
          expect(item[:attributes][:name]).to include("air")
        
        end

      end
    
      it 'returns an empty array when no items match the search criteria' do
        get '/api/v1/items/find_all', params: { min_price: 999999 }
        
        expect(response.status).to eq(200)  
        expect(JSON.parse(response.body)["data"]).to eq([])      
      end

    it "returns an error when a min price is less than 0" do
      get '/api/v1/items/find_all?min_price=-1'
    
      expect(response.status).to eq(400) 
    
      error = JSON.parse(response.body, symbolize_names: true)
    
      expect(error[:errors].first[:detail]).to eq('Price cannot be less than zero.')
    end
    it "returns an error when a max price is less than 0" do
      get '/api/v1/items/find_all?max_price=-1'
    
      expect(response.status).to eq(400) 
    
      error = JSON.parse(response.body, symbolize_names: true)
    
      expect(error[:errors].first[:detail]).to eq('Price cannot be less than zero.')
    end

    it "returns a 400 error when min price and name are sent" do
      get '/api/v1/items/find_all?name=alex&min_price=20'

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:errors].first[:detail]).to eq('Cannot filter by both price and name at the same time.')      
    end
    it "returns a 400 error when min price and name are sent" do
      get '/api/v1/items/find_all?name=alex&max_price=20'

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:errors].first[:detail]).to eq('Cannot filter by both price and name at the same time.')      
    end

    it "returns a 400 error when name is empty" do
      get '/api/v1/items/find_all?name'

      expect(response.status).to eq(400)



   end
   it "returns a 400 error when min_price is empty" do
     get '/api/v1/items/find_all?min_price='

     expect(response.status).to eq(400)
     error_response = JSON.parse(response.body, symbolize_names: true)
   end

   it "returns a 400 error when max_price is empty" do
     get '/api/v1/items/find_all?max_price='

     expect(response.status).to eq(400)
     error_response = JSON.parse(response.body, symbolize_names: true)
   end
    
  end
end
end