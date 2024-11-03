require 'rails_helper'

RSpec.describe Item, type: :model do
  before(:each) do
    @merchant = create(:merchant)
    @item1 = create(:item, name: 'airbuds', unit_price: 75.00, merchant: @merchant)
    @item2 = create(:item, name: 'hydroflask', unit_price: 20.00, merchant: @merchant)
    @item3 = create(:item, name: 'airpump', unit_price: 55.00, merchant: @merchant)
  end
  describe "associations" do
    it {should belong_to(:merchant) }
    it {should have_many(:invoice_items) }
    it {should validate_presence_of(:name)}
    it {should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }   
    it {should validate_presence_of(:merchant_id)}
    it {should validate_presence_of(:description)}
  end

  
  describe ".sorted_by_price" do
    it "returns items sorted by price lowest to highest" do

      expect(Item.sorted_by_price).to eq([@item2, @item3, @item1])
    end
  end

  describe ' find all items based on min price #find_items_by_price' do
    xit 'returns all items that match a minimum price parameter' do
      get '/api/v1/items/find_all', params: { min_price: 50.00 }
  
      expect(response).to be_successful
    
      itmes = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(2)
    
      expect(items).to eq([@item1, @item3])
    end
  end

  describe ' find all items based on max price #find_items_by_price' do
    xit 'returns all items that match a maximum price parameter' do
      get '/api/v1/items/find_all', params: { max_price: 70.00 }
  
      expect(response).to be_successful
    
      itmes = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(2)
    
      expect(items).to include(
        include(
          attributes: include(name: "hydroflask", unit_price: 20.00)
        ),
        include(
          attributes: include(name: "airpump", unit_price: 55.00)
        )
      )  
    end
  end

  describe ' find all itmes using #find_items_by_name' do
    xit 'returns all itmes that match a name' do
      get '/api/v1/items/find_all', params: { name: 'air' }

      expect(response).to be_successful
  
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.count).to eq(2) 
      expect(items).to include(
        include(
          attributes: include(name: "airbuds", price: 75.00)
        ),
        include(
          attributes: include(name: "airpump", price: 55.00)
        )
      )
    end
  end
end