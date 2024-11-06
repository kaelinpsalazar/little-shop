class InvoiceSerializer
  include JSONAPI::Serializer
  attributes  :customer_id, :merchant_id, :status
end