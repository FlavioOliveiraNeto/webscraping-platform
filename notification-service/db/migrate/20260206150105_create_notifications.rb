class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.string :event_type
      t.integer :task_id
      t.jsonb :payload

      t.timestamps
    end
  end
end
