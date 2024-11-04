FactoryBot.define do
  factory :customer do
    first_name { "John" }
    last_name { "Doe" }
    created_at { Time.current }
    updated_at { Time.current }
  end
end