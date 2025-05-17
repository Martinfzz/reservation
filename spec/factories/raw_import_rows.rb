FactoryBot.define do
  factory :raw_import_row do
    association :import_job

    data do
      {
        "ticket_number" => Faker::Number.unique.number(digits: 5),
        "reservation_reference" => Faker::Number.number(digits: 5),
        "reservation_date" => Faker::Date.backward(days: 30).to_s,
        "reservation_time" => Faker::Time.backward(days: 30, period: :evening).strftime("%H:%M"),
        "external_id_show" => Faker::Number.number(digits: 5),
        "title_show" => Faker::Book.title,
        "external_id_perf" => Faker::Number.number(digits: 5),
        "title_perf" => Faker::Book.genre,
        "start_date" => Faker::Date.forward(days: 10).to_s,
        "start_time" => Faker::Time.forward(days: 10, period: :evening).strftime("%H:%M"),
        "end_date" => Faker::Date.forward(days: 11).to_s,
        "end_time" => Faker::Time.forward(days: 11, period: :night).strftime("%H:%M"),
        "price" => Faker::Commerce.price(range: 10..100).to_s,
        "product_type" => Faker::Commerce.material,
        "sales_channel" => Faker::Company.name,
        "last_name" => Faker::Name.last_name,
        "first_name" => Faker::Name.first_name,
        "email" => Faker::Internet.email,
        "address" => Faker::Address.street_address,
        "postal_code" => Faker::Number.number(digits: 5),
        "country" => Faker::Address.country,
        "age" => Faker::Number.between(from: 18, to: 80),
        "gender" => [ "M", "F", "Other" ].sample
      }
    end
  end
end
