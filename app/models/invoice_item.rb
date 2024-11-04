class InvoiceItem < ApplicationRecord
  validates :item_id, :invoice_id, :quantity, :unit_price, presence: true
  belongs_to :item 
  belongs_to :invoice
end