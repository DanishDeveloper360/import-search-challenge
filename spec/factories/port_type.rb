FactoryBot.define do
    factory :port_type do
      name { Faker::Lorem.word }
      created_at { Faker::Date.between(from: 2.days.ago, to: Date.today) }
      updated_at { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    end
  end