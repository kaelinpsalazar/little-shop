class InvoiceSerializer
  include JSONAPI::Serializer
  attributes :id, :customer_id, :merchant_id, :status
end