class CreateScrapedVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :scraped_vehicles do |t|
      t.integer :task_id
      t.string :brand
      t.string :model
      t.string :price

      t.timestamps
    end
  end
end
