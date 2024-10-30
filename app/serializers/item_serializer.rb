class ItemSerializer
  include JSONAPI::Serializer

  attributes :name, :description, :unit_price, :merchant_id

  attribute :unit_price do |object|
    object.unit_price.to_f
  end

  attribute :merchant_id do |object|
    object.merchant_id.to_i
  end
end