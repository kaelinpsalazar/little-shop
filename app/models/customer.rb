class Customer < ApplicationRecord
  has_many :invoices
  has_many :merchants, through: :invoices
end