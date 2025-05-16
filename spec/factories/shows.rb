FactoryBot.define do
  factory :show do
    external_id { SecureRandom.uuid }
    title       { "Quartett" }
  end
end
