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

  describe 'scopes' do
    describe '.by_status' do
      context 'when filtering by "shipped"' do
        it 'returns only shipped invoices' do
          expect(Invoice.by_status('shipped')).to contain_exactly(@invoice1)
        end
      end

      context 'when filtering by "packaged"' do
        it 'returns only packaged invoices' do
          expect(Invoice.by_status('packaged')).to contain_exactly(@invoice2)
        end
      end

      context 'when filtering by "returned"' do
        it 'returns only returned invoices' do
          expect(Invoice.by_status('returned')).to contain_exactly(@invoice3)
        end
      end

      context 'when an invalid status is given' do
        it 'returns an empty collection' do
          expect(Invoice.by_status('invalid_status')).to be_empty
        end
      end
    end
  end
end