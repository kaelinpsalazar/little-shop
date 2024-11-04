class InvoiceSerializer
  include JSONAPI::Serializer

  attributes :customer_id, :merchant_id, :status

  attribute :customer_id do |object|
    object.customer_id.to_i
  end

  attribute :merchant_id do |object|
    object.merchant_id.to_i
  end

  attribute :status do |object|
    object.status.to_s
  end
end