require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:credit_card_number) }
    it { should validate_presence_of(:credit_card_expiration_date)}
    it { should validate_presence_of(:result) }    
  end

  describe 'associations' do
    it { should belong_to(:invoice) }
  end
end