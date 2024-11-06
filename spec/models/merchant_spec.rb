require 'rails_helper'

RSpec.describe Merchant, type: :model do
  before(:each) do
    @merchant1 = create(:merchant, name: "Gnome Depot", created_at: 2.days.ago)
    @merchant2 = create(:merchant, name: "Bloodbath and Beyond", created_at: 1.day.ago)
    @merchant3 = create(:merchant, name: "The Philosopher's Scone", created_at: Time.now)
    @items = create_list(:item, 5, merchant: @merchant1)
    @customer = create(:customer)

    @returned_invoice = Invoice.create(
      merchant_id: @merchant1.id,
      customer_id: @customer.id,  
      status: 'returned',
      created_at: Time.now,
      updated_at: Time.now
    )
    @pending_invoice = Invoice.create(
      merchant_id: @merchant1.id,
      customer_id: @customer.id,  
      status: 'pending',
      created_at: Time.now,
      updated_at: Time.now
    )
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it {should have_many(:items).dependent(:destroy)}
    it {should have_many(:invoices).dependent(:destroy)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe ".sorted_by_created_at" do 
    it 'returns merchants sorted by created at in dec. order' do
      expect(Merchant.sorted_by_created_at).to eq([@merchant3, @merchant2, @merchant1])
    end
  end

  describe '.with_returned_status' do
    it 'returns merchants with returned invoices' do
      expect(Merchant.with_returned_status).to include(@merchant1)
      expect(Merchant.with_returned_status).not_to include(@merchant2, @merchant3)
    end
  end

  describe '.with_item_count' do 
    it 'returns merchants with item_count' do
      merchant = Merchant.find(@merchant1.id)
      item_count = merchant.item_count
      expect(merchant.item_count).to eq(5)
    end
  end

  describe '.fetch_merchants' do
    it 'returns sorted merchants when sorted param is age' do
      expect(Merchant.fetch_merchants(sorted: 'age')).to eq([@merchant3, @merchant2, @merchant1])
    end
  
    it 'returns merchants with returned status when status param is returned' do
      expect(Merchant.fetch_merchants(status: 'returned')).to include(@merchant1)
      expect(Merchant.fetch_merchants(status: 'returned')).not_to include(@merchant2, @merchant3)
    end
  
    it 'returns all merchants when no specific params are provided' do
      expect(Merchant.fetch_merchants({})).to include(@merchant1, @merchant2, @merchant3)
    end
  end

  describe ' find one merchant using #find_merchant_by_name' do
    it 'returns a merchant that matches a name search' do
      params1 = {name: 'gnome'}
      params2 = {name: 'th'}
      params3 = {name: 'ScoNe'}
      params4 = {name: 'xyz'}

      expect(Merchant.find_merchant_by_name(params1)).to eq(@merchant1)
      expect(Merchant.find_merchant_by_name(params2)).to eq(@merchant2)
      expect(Merchant.find_merchant_by_name(params3)).to eq(@merchant3)
      expect(Merchant.find_merchant_by_name(params4)).to eq(nil)
    end
  end
end