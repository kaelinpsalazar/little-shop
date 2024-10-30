FactoryBot.define do
  factory :merchant do
    name { Faker::Movies::StarWars.character }
  end
end