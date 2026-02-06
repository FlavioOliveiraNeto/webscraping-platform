class ScrapedVehicle < ApplicationRecord
  validates :task_id, :brand, :model, :price, presence: true
end