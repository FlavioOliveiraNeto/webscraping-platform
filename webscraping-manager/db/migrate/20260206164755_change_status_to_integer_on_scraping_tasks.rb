class ChangeStatusToIntegerOnScrapingTasks < ActiveRecord::Migration[8.1]
  def up
    change_column :scraping_tasks, :status, :integer, using: 'status::integer'
  rescue
    remove_column :scraping_tasks, :status
    add_column :scraping_tasks, :status, :integer, default: 0, null: false
  end

  def down
    change_column :scraping_tasks, :status, :string
  end
end
