FactoryBot.define do
    factory :port do
      name { Faker::Name.unique.name }
      code { Faker::Name.unique.name }
      created_at { Faker::Date.between(from: 2.days.ago, to: Date.today) }
      updated_at { Faker::Date.between(from: 2.days.ago, to: Date.today) }
      port_type_id { nil }
    end
  end