class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
end