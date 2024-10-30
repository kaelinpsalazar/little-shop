require "rails_helper"

RSpec.describe "Mechant", type: :request do
    before(:each) do 
        @merchant1 = Merchant.create!(name: "Gnome Depot")
        @merchant2 = Merchant.create!(name: "Bloodbath and Beyond")
        @merchant3 = Merchant.create!(name: "The Philosopher's Scone")
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
        xit "creates a new merchant" do
            merchant_attributes = {name: "Gnome Depot"}

            post "/api/v1/merchants#create", params: {merchant: merchant_attributes}

            merchant = JSON.parse(response.body, symbolize_names: true)[:data].first

            expect(merchant[:attributes][:name]).to eq(merchant_attributes[:name])
        end
    end

  describe "edits a merchant with #update" do
        xit "can update an existing merchant" do
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
       xit "can delete an existing merchant" do

            expect(Merchant.count).to eq(3)

            delete "/api/v1/merchants/#{@merchant2.id}"

            expect(response).to be_successful
            expect(Merchant.count).to eq(2)
            expect{Merchant.find(@merchant2.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
    end

    describe "can find customers for merchant ID" do
        it "returns customer name if given merchant ID" do
            customer = Customer.create( 
                first_name: "Mary", 
                last_name: "Shelley" 
                )
            Invoice.create!(merchant: @merchant1, customer: customer)
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
end