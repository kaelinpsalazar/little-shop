class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  validates :name, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true
  validates :description, presence: true

  def self.sorted_by_price
    order(unit_price: :asc)
  end
end