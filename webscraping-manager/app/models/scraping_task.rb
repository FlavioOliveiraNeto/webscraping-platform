class ScrapingTask < ApplicationRecord
  validates_with WebmotorsUrlValidator

  validates :source_url, presence: true
  validates :title, presence: true
  validates :user_id, presence: true

  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }
end