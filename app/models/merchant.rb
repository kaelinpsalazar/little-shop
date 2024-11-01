class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :customers, through: :invoices

  def self.sorted_by_created_at
    order(created_at: :desc)
  end

  def self.with_returned_status
    joins(:invoices).where(invoices: { status: 'returned' }).distinct
  end

  def self.with_item_count
    select("merchants.*, COUNT(items.id) AS item_count")
      .left_joins(:items)
      .group("merchants.id")
  end

  def self.fetch_merchants(params)
    if params[:sorted] == 'age'
      sorted_by_created_at
    elseif params[:status] == 'returned'
      with_returned_status
    elseif params[:count] == 'true'
      with_item_count
    else
      Merchant.all 
    end
  end
end