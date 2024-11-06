class Merchant < ApplicationRecord
  validates :name, presence: true
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
    merchants = Merchant.all
    merchants = merchants.sorted_by_created_at if params[:sorted] == 'age'
    merchants = merchants.with_returned_status if params[:status] == 'returned'
    merchants = merchants.with_item_count
    merchants = merchants.order(:id) unless params[:sorted]      
    merchants
  end

  
  def item_count
    items.count
  end

  def self.find_merchant_by_name(params)
    merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").first
    merchant
  end
end