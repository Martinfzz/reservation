FactoryBot.define do
  factory :show do
    external_id { Faker::Number.unique.number(digits: 5) }
    title       { "Quartett" }
  end
end
