class Invoice < ApplicationRecord
  validates :customer_id, :merchant_id, :status, presence: true
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions

  def self.for_merchant_with_status(merchant_id, status)
    valid_statuses = ["shipped", "returned", "packaged"]
    
    if valid_statuses.include?(status)
      where(merchant_id: merchant_id, status: status)
    else
      []  
    end
  end

  def self.by_status(status)
    return [] unless valid_status?(status)

    where(status: status)
  end

  def self.valid_status?(status)
    ["shipped", "returned", "packaged"].include?(status)
  end
end