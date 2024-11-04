FactoryBot.define do
  factory :customer do
    id { SecureRandom.uuid } # assuming the id is a UUID
    first_name { "John" }
    last_name { "Doe" }
    created_at { Time.current }
    updated_at { Time.current }
  end
end