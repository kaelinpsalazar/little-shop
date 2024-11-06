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
    merchants = if params[:sorted] == 'age'
                  sorted_by_created_at
                elsif params[:status] == 'returned'
                  with_returned_status
                else
                  Merchant.all
                end
    merchants = merchants.with_item_count 
    merchants 
  end

  
  def item_count
    items.count
  end

  def self.find_merchant_by_name(params)
    merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").first
    merchant
  end

  def self.find_by_params(params)
    if params[:name].present?
      merchants = where("name ILIKE ?", "%#{params[:name]}%").order(:name)
    end
    merchants
  end

  
end