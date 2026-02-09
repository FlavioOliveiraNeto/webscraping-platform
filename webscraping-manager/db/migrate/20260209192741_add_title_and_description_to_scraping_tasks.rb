class AddTitleAndDescriptionToScrapingTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :scraping_tasks, :title, :string
    add_column :scraping_tasks, :description, :text
  end
end
