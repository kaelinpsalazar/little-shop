require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "associations" do
    it { should belong_to(:merchant) }
    it {should have_many(:invoice_items) }
    it {should validate_presence_of(:name)}
    it { should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }   
    it {should validate_presence_of(:merchant_id)}
    it {should validate_presence_of(:description)}
  end

  
  describe ".sorted_by_price" do
    it "returns items sorted by price lowest to highest" do
      merchant = create(:merchant)
      item1 = create(:item, unit_price: 75.00, merchant: merchant)
      item2 = create(:item, unit_price: 20.00, merchant: merchant)
      item3 = create(:item, unit_price: 55.00, merchant: merchant)

      expect(Item.sorted_by_price).to eq([item2, item3, item1])
    end
  end

  describe ' find all itmes using #find_items_by_price' do
    it 'returns all itmes that match a price parameter' do

    end
  end

  describe ' find all itmes using #find_items_by_name' do
    it 'returns all itmes that match a price parameter' do

    end
  end
end