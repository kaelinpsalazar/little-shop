class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers
end