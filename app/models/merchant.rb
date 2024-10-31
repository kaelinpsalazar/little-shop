class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :customers, through: :invoices

  def self.sorted_by_created_at
    order(created_at: :desc)
  end

  def self.with_returned_status
    joins(:invoices).where(invoices: { status: 'returend'}).distinct
  end

  def self.with_item_count
    merchants = Merchant.includes(:items)
    merchants.map do |merchant|
      merchant.attributes.merge('item_count => merchant.itmes.size')
    end

  end
end