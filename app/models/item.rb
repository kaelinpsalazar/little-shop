class Item < ApplicationRecord
  validates :name, :unit_price, :merchant_id, :description, presence: true
  belongs_to :merchant
  has_many :invoice_items

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

  def self.find_by_params(params)
    items = if params[:name].present?
      where("name ILIKE ?", "%#{params[:name]}%").order(:name).limit(1)
    elsif params[:min_price].present? && params[:max_price].present?
      where("unit_price >= ? AND unit_price <= ?", params[:min_price].to_f, params[:max_price].to_f).order(:name).limit(1)
    elsif params[:min_price].present?
      where("unit_price >= ?", params[:min_price].to_f).order(:name).limit(1)
    elsif params[:max_price].present?
      where("unit_price <= ?", params[:max_price].to_f).order(:name).limit(1)
    end
  items.first
  end
end