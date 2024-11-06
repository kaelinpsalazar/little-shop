require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before(:each) do
    @merchant = create(:merchant)
    @customer = create(:customer)
    @invoice1 = create(:invoice, merchant: @merchant, customer: @customer, status: 'shipped')
    @invoice2 = create(:invoice, merchant: @merchant, customer: @customer, status: 'packaged')
    @invoice3 = create(:invoice, merchant: @merchant, customer: @customer, status: 'returned')
  end

  describe 'validations' do
    it { should validate_presence_of(:customer_id) }
    it { should validate_presence_of(:merchant_id) }
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
  end

  describe 'valid_status?' do
      it 'returns true for "shipped"' do
        expect(Invoice.valid_status?('shipped')).to be_truthy
      end
      
      it 'returns true for "returned"' do
        expect(Invoice.valid_status?('returned')).to be_truthy
      end
      
      it 'returns true for "packaged"' do
        expect(Invoice.valid_status?('packaged')).to be_truthy
      end

      it 'returns a status' do
        expect(Invoice.by_status('shipped')).not_to be_empty
        expect(Invoice.by_status('returned')).not_to be_empty
      end
    
      it 'returns an empty array when invalid' do
        expect(Invoice.by_status('invalid_status')).to eq([])
      end
    
      it 'returns false for "invalid_status"' do
        expect(Invoice.valid_status?('invalid_status')).to be_falsey
      end
  end

  describe 'for_merchant_with_status' do
      it 'returns only shipped invoices' do
        expect(Invoice.for_merchant_with_status(@merchant.id, 'shipped')).to contain_exactly(@invoice1)
      end

      it 'returns only packaged invoices' do
        expect(Invoice.for_merchant_with_status(@merchant.id, 'packaged')).to contain_exactly(@invoice2)
      end

      it 'returns only returned invoices' do
        expect(Invoice.for_merchant_with_status(@merchant.id, 'returned')).to contain_exactly(@invoice3)
      end
    
      it 'returns nil for an invalid status' do
        expect(Invoice.for_merchant_with_status(@merchant.id, 'invalid_status')).to eq([])
      end
  end
end