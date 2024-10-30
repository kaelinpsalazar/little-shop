require 'faker'

FactoryBot.define do
  factory :item do
    name { Faker::Movies::StarWars.character }             
    description { Faker::Movies::StarWars.quote }         
    unit_price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    association :merchant  # Ensures the item is associated with a merchant
  end
end