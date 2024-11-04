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

  describe "find items by price" do
    it "returns items with a minimim and/or maximum price parameter" do
      params1 = {min_price: 50.00}
      params2 = {max_price: 30.00}
      params3 = {min_price: 50.00, max_price: 70.00}

      expect(Item.find_items_by_price(params1)).to eq([@item1, @item3])
      expect(Item.find_items_by_price(params2)).to eq([@item2])
      expect(Item.find_items_by_price(params3)).to eq([@item3])
    end
  end

  describe "find items by name" do
    it "returns items with a name parameter" do

      expect(Item.find_items_by_name('air')).to eq([@item1, @item3])
      expect(Item.find_items_by_name('flask')).to eq([@item2])
      expect(Item.find_items_by_name('giberish')).to eq([])
    end
  end
end