require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:merchant_id) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:description)}
  end

  before(:each) do
    @merchant = create(:merchant)
    @item1 = create(:item, name: 'airbuds', unit_price: 75.00, merchant: @merchant)
    @item2 = create(:item, name: 'hydroflask', unit_price: 20.00, merchant: @merchant)
    @item3 = create(:item, name: 'airpump', unit_price: 55.00, merchant: @merchant)
  end
  
  describe "associations" do
    it {should belong_to(:merchant) }
    it {should have_many(:invoice_items) }
  end
  
  describe ".sorted_by_price" do
    it "returns items sorted by price lowest to highest" do

      expect(Item.sorted_by_price).to eq([@item2, @item3, @item1])
    end
  end
end