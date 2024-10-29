class Customer < ApplicationRecord
  has_many :invoices
end