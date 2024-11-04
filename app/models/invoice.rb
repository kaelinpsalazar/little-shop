class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer

  def self.for_merchant_with_status(merchant_id, status)
    vaild_statuses = %w[shiped returned packaged]
    return none unless valid_statuses.include?(status)

    where(merchant_id: merchant_id, status: status)
  end
end
