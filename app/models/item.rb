class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  validates :name, presence: true
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :merchant_id, presence: true
  validates :description, presence: true

  def self.sorted_by_price
    order(unit_price: :asc)
  end

  def self.find_items_by_price(params)
    items = all
    items = items.where("unit_price >= ?", params[:min_price]) if params[:min_price].present?
    items = items.where("unit_price <= ?", params[:max_price]) if params[:max_price].present?
    items
  end
  
  def self.find_items_by_name(name)
    where("name ILIKE ?", "%#{name}%")
  end
end