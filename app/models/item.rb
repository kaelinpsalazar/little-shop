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
end