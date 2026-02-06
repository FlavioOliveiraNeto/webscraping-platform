FactoryBot.define do
  factory :scraped_vehicle do
    task_id { 1 }
    brand { "Honda" }
    model { "Civic" }
    price { "120000" }
  end
end