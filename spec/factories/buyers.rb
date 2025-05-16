FactoryBot.define do
  factory :buyer do
    first_name { "John" }
    last_name  { "Doe" }
    email      { Faker::Internet.unique.email }
  end
end
