class CreateScrapingTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :scraping_tasks do |t|
      t.string  :source_url, null: false
      t.integer :status, default: 0, null: false
      t.integer :user_id, null: false
      t.boolean :notification_sent, default: false, null: false

      t.timestamps
    end
  end
end
