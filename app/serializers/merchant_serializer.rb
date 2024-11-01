class MerchantSerializer
  include JSONAPI::Serializer

  attributes :name, :item_count

  def item_count
    object.items.count
  end
end
  