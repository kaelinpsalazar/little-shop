require 'rails_helper'

RSpec.describe "Fetch All Items" do
  before(:each) do
    @item1 = Item.new(
      name: "Item Nemo Facere",
      description: "Sunt eum id eius magni consequuntur delectus verit...",
      unit_price: 42.91,
      merchant_id: 1
      )

    @item2 = Item.new(
      name: "Item Expedita Aliquam",
      description: "Voluptate aut labore qui illum tempore eius. Corru...",
      unit_price: 687.23,
      merchant_id: 1
      )
    @item3 = Item.new(    
      name: "Item Provident At",
      description: "Numquam officiis reprehenderit eum ratione neque t...",
      unit_price: 159.25,
      merchant_id: 1
      )
  end
end