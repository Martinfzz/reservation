FactoryBot.define do
  factory :performance do
    association :show
    external_id { Faker::Number.unique.number(digits: 5) }
    title { "Le roi Lear" }
    start_date { Date.today }
    start_time { Time.now }
    end_date { Date.today + 1 }
    end_time { Time.now + 2.hours }
  end
end
