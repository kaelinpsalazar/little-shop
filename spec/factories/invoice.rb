FactoryBot.define do
  factory :invoice do
    association :customer
    association :merchant
    status { 'pending' }
    created_at { Time.now }
    updated_at { Time.now }
  end
end