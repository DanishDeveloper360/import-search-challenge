FactoryBot.define do
    factory :port do
      name { Faker::Name.name }
      code { Faker::Name.unique.name }
      created_at { Faker::Date.between(from: 2.days.ago, to: Date.today) }
      updated_at { Faker::Date.between(from: 2.days.ago, to: Date.today) }
      city { Faker::Name.name }
      oceans_insights_code { Faker::Name.unique.name }
      port_type_id { nil }
    end
  end