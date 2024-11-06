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

  def self.search_params(params)
    result = {}

    if params[:min_price].present? && params[:min_price].to_f < 0
      result[:errors] = [{ detail: 'Price cannot be less than zero.' }]
      return result
    elsif params[:max_price].present? && params[:max_price].to_f < 0
      result[:errors] = [{ detail: 'Price cannot be less than zero.' }]
      return result
    elsif params[:min_price].present? && params[:name].present?
      result[:errors] = [{ detail: 'Cannot filter by both price and name at the same time.' }]
      return result
    elsif params[:max_price].present? && params[:name].present?
      result[:errors] = [{ detail: 'Cannot filter by both price and name at the same time.' }]
      return result
    end

    items = all
    items = items.where('unit_price >= ?', params[:min_price]) if params[:min_price].present?
    items = items.where('unit_price <= ?', params[:max_price]) if params[:max_price].present?
    items = items.where('name ILIKE ?', "%#{params[:name]}%") if params[:name].present?

    result[:items] = items
    result
  end

end