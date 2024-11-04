FactoryBot.define do
  factory :invoice do
    id { SecureRandom.uuid } # assuming the id is a UUID
    customer
    merchant
    status { "shipped" } # default status; can be overridden
    created_at { Time.current }
    updated_at { Time.current }
  end
end