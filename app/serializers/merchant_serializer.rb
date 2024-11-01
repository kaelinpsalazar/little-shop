class MerchantSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :item_count do |merchant, params|
    params[:include_item_count] ? merchant.item_count : nil
  end
  
end