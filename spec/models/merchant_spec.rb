require 'rails_helper'

RSpec.describe Merchant, type: :model do
  RSpec.describe Merchant, type: :model do
    before(:each) do
      @merchant1 = create(:merchant, created_at: 2.days.ago)
      @merchant2 = create(:merchant, created_at: 1.day.ago)
      @merchant3 = create(:merchant)
      @returned_invoice = create(:invoice, merchant: @merchant1, status: 'returned')
      create_list(:item, 5, merchant: @merchant1)
    end

  describe "associations" do
    it {should have_many(:items).dependent(:destory)}
    it {should have_many(:invoices).dependent(:destroy)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe ".sorted_by_created_at" do 
    it 'returns merchants sorted by created at in dec. order' do
      expect(Merchant.sorted_by_created_at).to eq([@mercahnt3, @merchant2, @merchant1])
    end
  end

  describe ".with_returned_status" do
    it 'returns mercahnts with at least one returned invoice' do
      expect(Merchant.with_returned_status).to include(@merchant1)
      expect(Merchant.with_returned_status).not_to include(@merchant2, @merchant3)
    end
  end

  describe '.with_item_count' do 
    it 'returns merchants with item_count' do
      merchant_with_count = Merchant.with_item_count.find(@merchant1.id)
      expect(merchant_with_count.item_count).to eq(5)
    end
  end
end