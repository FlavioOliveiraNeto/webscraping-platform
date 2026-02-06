class Notification < ApplicationRecord
  EVENT_TYPES = %w[
    task_created
    task_completed
    task_failed
  ].freeze

  validates :event_type, presence: true, inclusion: { in: EVENT_TYPES }
  validates :task_id, presence: true
  validates :payload, presence: true

  scope :failures, -> { where(event_type: 'task_failed') }
end