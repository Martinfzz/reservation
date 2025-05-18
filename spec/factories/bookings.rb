FactoryBot.define do
  factory :booking do
    association :buyer
    association :performance

    ticket_number         { Faker::Number.unique.number(digits: 5) }
    reservation_reference { Faker::Number.unique.number(digits: 5) }
    reservation_date      { Date.today }
    reservation_time      { Time.now }
    price                 { 29.99 }
    product_type          { "Abonnement" }
    sales_channel         { "GUICHET" }
  end
end
