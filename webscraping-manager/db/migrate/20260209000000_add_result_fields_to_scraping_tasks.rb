class AddResultFieldsToScrapingTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :scraping_tasks, :brand, :string
    add_column :scraping_tasks, :model, :string
    add_column :scraping_tasks, :price, :string
    add_column :scraping_tasks, :error_message, :text
  end
end
