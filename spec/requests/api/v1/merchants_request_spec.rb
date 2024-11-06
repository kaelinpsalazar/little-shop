require "rails_helper"

RSpec.describe "Mechant", type: :request do
    before(:each) do 
        Merchant.delete_all
        @merchant1 = Merchant.create!(name: "Gnome Depot")
        @merchant2 = Merchant.create!(name: "Bloodbath and Beyond")
        @merchant3 = Merchant.create!(name: "The Philosopher's Scone")
    end

  describe "Can get all merchants with #index" do
      it "Can return all merchants" do
        get "/api/v1/merchants"
        
        expect(response).to be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(merchant.count).to eq(3)

        merchant.each do |merchant|
          expect(merchant).to have_key(:id)
          expect(merchant[:id].to_s).to be_a(String)

          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to be_a(String)
        end
      end
  end

  describe "Can get one merchant with #show" do
        it "can return one merchant" do
            get "/api/v1/merchants/#{@merchant1.id}"

            merchant = JSON.parse(response.body, symbolize_names: true)[:data]

            expect(response).to be_successful
            expect(response).to have_http_status(:ok)

            expect(merchant).to have_key(:id)
            expect(merchant[:id]).to eq(@merchant1.id.to_s)

            expect(merchant[:attributes]).to have_key(:name)
            expect(merchant[:attributes][:name]).to eq(@merchant1.name)
        end
    end

    describe "make a new merchant with #create" do
        it "creates a new merchant" do
            merchant_attributes = {name: "Boo Value"}
            
            post "/api/v1/merchants", params: {merchant: merchant_attributes}
            
            expect(response.status).to eq(201)
            merchant = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(merchant[:attributes][:name]).to eq("Boo Value")

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

    describe "deletes a merchant with #delete" do
        it "can delete an existing merchant" do

            expect(Merchant.count).to eq(3)

            delete "/api/v1/merchants/#{@merchant2.id}"

            expect(response).to be_successful
            expect(Merchant.count).to eq(2)
            expect{Merchant.find(@merchant2.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
    end

    describe "returns all items for a merchant with #index" do
      it "can return all the items for a specific merchant" do
        item1 = Item.create(
          name: "socks",
          description: "keep feet warm",
          unit_price: 99.99,
          merchant_id: @merchant1.id
        )

            item2 = Item.create(
            name: "shovel",
            description: "bury bodies",
            unit_price: 50.01,
            merchant_id: @merchant1.id
            )

            get "/api/v1/merchants/#{@merchant1.id}/items"
            expect(response).to be_successful

            item_info = JSON.parse(response.body, symbolize_names: true)       


        item_info[:data].each do |item|
          expect(item[:type]).to eq('item')
          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes]).to have_key(:merchant_id)
          expect(item[:attributes][:merchant_id]).to eq(@merchant1.id)
        end
      end
    end

    describe "can find customers for merchant ID" do
        it "returns customer name if given merchant ID" do
            customer = Customer.create( 
                first_name: "Mary", 
                last_name: "Shelley" 
                )
            Invoice.create!(merchant: @merchant1, customer: customer, status: 'completed')
            get "/api/v1/merchants/#{@merchant1.id}/customers" 
            
            expect(response).to be_successful 
            expect(response).to have_http_status(200)
                        
            customer_info = JSON.parse(response.body, symbolize_names: true)

            expect(customer_info[:data]).to be_an(Array)
            customer1 = customer_info[:data].first            
            
            expect(customer1).to have_key(:id)
            expect(customer1[:attributes]).to have_key(:first_name) 
            expect(customer1[:attributes]).to have_key(:last_name)
        end
    end

    describe "sad paths" do   
        it "will return an error if all params are not valid" do
          merchant_params = {
            merchant: {
              name: ""
            }
          }
    
          headers = {"CONTENT_TYPE" => "application/json"} 
          post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant_params)
    
          expect(response).to_not be_successful
          expect(response.status).to eq(422)
    
    
          created_merchant = JSON.parse(response.body, symbolize_names: true)
    
          expect(created_merchant[:errors]).to be_a(Array)
          expect(created_merchant[:errors].first[:status]).to eq("422")
          expect(created_merchant[:errors].first[:title]).to eq("Unprocessable Entity")
          expect(created_merchant[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
        end

        it "returns a 404 status with error message when item doesn't exist" do
            get "/api/v1/merchants/219058/items"
      
            expect(response).to_not be_successful
            expect(response.status).to eq(404)
      
            get_merchant = JSON.parse(response.body, symbolize_names: true)
      
            expect(get_merchant[:errors]).to be_a(Array)
            expect(get_merchant[:errors].first[:status]).to eq("404")
            expect(get_merchant[:errors].first[:title]).to eq("Resource Not Found")
            expect(get_merchant[:errors].first[:detail]).to eq("Couldn't find Merchant with 'id'=219058")
          end

    
        it "returns a 404 status with error message when item doesn't exist" do
          get "/api/v1/merchants/219058"
    
          expect(response).to_not be_successful
          expect(response.status).to eq(404)
    
          get_merchant = JSON.parse(response.body, symbolize_names: true)
    
          expect(get_merchant[:errors]).to be_a(Array)
          expect(get_merchant[:errors].first[:status]).to eq("404")
          expect(get_merchant[:errors].first[:title]).to eq("Resource Not Found")
          expect(get_merchant[:errors].first[:detail]).to eq("Couldn't find Merchant with 'id'=219058")
        end

        it "will return an error if given an empty object" do
            merchant_params = {        
            }
      
            headers = { "CONTENT_TYPE" => "application/json" }
      
            patch "/api/v1/merchants/4", headers: headers, params: JSON.generate(merchant: merchant_params)
            expect(response).to_not be_successful
            expect(response.status).to eq(400)
      
      
            created_merchant = JSON.parse(response.body, symbolize_names: true)
      
            expect(created_merchant[:errors]).to be_a(Array)
            expect(created_merchant[:errors].first[:status]).to eq("400")
            expect(created_merchant[:errors].first[:title]).to eq("Bad Request")
            expect(created_merchant[:errors].first[:detail]).to eq("param is missing or the value is empty: merchant")
          end

          it "handles errors for customers for given merchant if given invalid merchant" do
            get "/api/v1/merchants/990099/customers"
        
            expect(response).to_not be_successful
            expect(response.status).to eq(404)

            get_merchant = JSON.parse(response.body, symbolize_names: true)
    
            expect(get_merchant[:errors]).to be_a(Array)
            expect(get_merchant[:errors].first[:status]).to eq("404")
            expect(get_merchant[:errors].first[:title]).to eq("Resource Not Found")
            expect(get_merchant[:errors].first[:detail]).to eq("Couldn't find Merchant with 'id'=990099")
          end

          it 'returns "Error" for any other status' do
            expect(ErrorSerializer.error_title(408)).to eq("Error")
            expect(ErrorSerializer.error_title(403)).to eq("Error")
            expect(ErrorSerializer.error_title(401)).to eq("Error")
          end
      end

  describe 'find one merchant based on filtering' do
    it 'returns one merchant that matchs a name using #find_merchant_by_name(params)' do
    merchant2 = Merchant.create!(name: "Bloodbath and Beyond")
    merchant1 = Merchant.create!(name: "Gblood Depot")

    get '/api/v1/merchants/find/?name=bloo'

    expect(response).to be_successful

    
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    # binding.pry
    expect(merchant[:attributes][:name]).to eq("Bloodbath and Beyond")
    end

    it "returns a 400 code when there is no input" do
        get '/api/v1/merchants/find'
        
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      
        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Invalid search term")
      end
  end


#   describe 'find all merchants with filter' do
#     it 'returns all merchants that match the name search' do
#         create(:merchant, name: "Gnome Depot")
#         create(:merchant, name: "Gnome Palace")
#         create(:merchant, name: "Other Shop")

    
#         get '/api/v1/merchants/find_all', params: { name: 'Gnome' }
    
#         expect(response).to be_successful
#         merchants = JSON.parse(response.body, symbolize_names: true)[:data]
#         expect(merchants.count).to eq(3)
#         expect(merchants[0][:attributes][:name]).to include("Gnome")
#       end
#   end

  
end