class Invoice < ApplicationRecord
  validates :customer_id, :merchant_id, :status, presence: true
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions

  def self.for_merchant_with_status(merchant_id, status)
    vaild_statuses = %w[shiped returned packaged]
    return none unless valid_statuses.include?(status)

    where(merchant_id: merchant_id, status: status)
  end

end
