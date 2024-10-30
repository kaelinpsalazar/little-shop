class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  scope :sorted_by_price, -> { order(unit_price: :asc) }
end