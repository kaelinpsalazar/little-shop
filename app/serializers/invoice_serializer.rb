class InvoiceSerializer
  include JSONAPI::Serializer
  attributes :id, :customer_id, :merchant_id, :status, :created_at, :updated_at
end