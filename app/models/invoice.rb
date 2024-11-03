class Invoice < ApplicationRecord
  validates :customer_id, :merchant_id, :status, presence: true
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
end
