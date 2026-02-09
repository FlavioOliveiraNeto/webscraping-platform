FactoryBot.define do
  factory :scraping_task do
    title { "Tarefa de Scraping" }
    description { "Descrição da tarefa de scraping" }
    source_url { 'https://www.webmotors.com.br/carros/estoque' }
    status { :pending }
    user_id { 1 }
    notification_sent { false }

    trait :invalid_url do
      source_url { 'https://www.google.com' }
    end
  end
end
