FactoryBot.define do
  factory :booking do
    association :buyer
    association :performance

    ticket_number         { SecureRandom.hex(5) }
    reservation_reference { SecureRandom.uuid }
    reservation_date      { Date.today }
    reservation_time      { Time.now }
    price                 { 29.99 }
    product_type          { "Abonnement" }
    sales_channel         { "GUICHET" }
  end
end
