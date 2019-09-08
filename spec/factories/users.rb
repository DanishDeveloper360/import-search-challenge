FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { 'test@me.com' }
    password { 'testPassword' }
  end
end