FactoryBot.define do
  factory :notification do
    event_type { 'task_created' }
    task_id { 1 }
    payload { { url: 'https://webmotors.com.br', user_agent: 'Mozilla' } }

    trait :failed do
      event_type { 'task_failed' }
      payload { { error: 'Timeout connection' } }
    end
  end
end